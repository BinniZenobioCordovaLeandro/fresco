import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/features/core/bloc/request_bloc.dart';
import 'package:myapp/features/core/repositories/firestore.repository.dart';
import 'package:myapp/features/core/ui/components/RequestButton.component.dart';
import 'package:myapp/shared/services/firestore.service.dart';

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    final position = useState<Position?>(null);
    final service = FirestoreService();
    final firestore = RequestRepository(service);

    return BlocProvider(
      create: (context) => RequestBloc(firestore),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Solicita agua potable a domicilio"),
        ),
        body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: const LatLng(51.5, -0.09),
            initialZoom: 15,
            maxZoom: 19,
            minZoom: 10,
            onMapReady: () {},
          ),
          children: [
            TileLayer(
              tileProvider: CancellableNetworkTileProvider(),
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.app',
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => {},
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    position.value?.latitude ?? 0.0,
                    position.value?.longitude ?? 0.0,
                  ),
                  child: const Icon(Icons.location_on),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder(
                        future: Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            position.value = snapshot.data as Position;
                            WidgetsFlutterBinding.ensureInitialized()
                                .addPostFrameCallback(
                              (_) {
                                mapController.move(
                                  LatLng(position.value?.latitude ?? 0.0,
                                      position.value?.longitude ?? 0.0),
                                  15,
                                );
                              },
                            );
                            return RequestButtonComponent(
                              latitude: position.value!.latitude,
                              longitude: position.value!.longitude,
                            );
                          } else {
                            return const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                Text('Obteniendo ubicación...'),
                              ],
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
