import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/features/core/bloc/request_bloc.dart';
import 'package:myapp/features/core/repositories/firestore.repository.dart';
import 'package:myapp/features/core/ui/components/RequestButton.component.dart';
import 'package:myapp/shared/services/firestore.service.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();
    final firestore = RequestRepository(service);
    return BlocProvider(
      create: (context) => RequestBloc(firestore),
      child: _MyHomePage(),
    );
  }
}

class _MyHomePage extends HookWidget {
  static final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final lastLatitude = useState<double?>(null);
    final lastLongitude = useState<double?>(null);

    final markers = useState<List<Marker>>([]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("AGUATERO a Domicilio"),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: const LatLng(-12.082528967716554, -76.92929540334258),
          initialZoom: 15,
          maxZoom: 19,
          minZoom: 10,
          onMapReady: () {
            Future.delayed(
              const Duration(seconds: 2),
            ).then(
              (value) {
                debugPrint('${DateTime.now()} InitialRequest');
                BlocProvider.of<RequestBloc>(context).add(InitialRequest());
              },
            );
          },
        ),
        children: [
          TileLayer(
            tileProvider: CancellableNetworkTileProvider(),
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => {},
              ),
            ],
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 45,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              maxZoom: 15,
              markers: markers.value,
              builder: (context, markers) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue),
                  child: Center(
                    child: Text(
                      markers.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          BlocConsumer<RequestBloc, RequestState>(listener: (context, state) {
            if (state is PositionSuccess) {
              lastLatitude.value = state.latitude;
              lastLongitude.value = state.longitude;
              mapController.move(
                LatLng(state.latitude, state.longitude),
                20,
              );
              markers.value = [
                ...markers.value,
                Marker(
                  point: LatLng(state.latitude, state.longitude),
                  child: const Icon(Icons.my_location_outlined),
                ),
              ];
            }
            if (state is ListRequestSuccess) {
              debugPrint('${DateTime.now()} ListRequestSuccess');
              var requests = state.requests;
              markers.value = requests
                  .map(
                    (e) => Marker(
                      point: LatLng(e.latitude!, e.longitude!),
                      child: const Icon(
                        Icons.water_damage,
                        color: Colors.blue,
                      ),
                    ),
                  )
                  .toList();
            }
          }, builder: (context, state) {
            return const SizedBox();
          }),
          Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Anuncia que quieres agua con un click y un aguatero llegara a tu ubicacion.",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (lastLatitude.value != null && lastLongitude.value != null)
                  ? RequestButtonComponent(
                      latitude: lastLatitude.value!,
                      longitude: lastLongitude.value!,
                    )
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        Text('Localizando tu ubicación...'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
