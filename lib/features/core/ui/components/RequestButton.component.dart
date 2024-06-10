import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/core/bloc/request_bloc.dart';

class RequestButtonComponent extends StatelessWidget {
  final double latitude;
  final double longitude;

  const RequestButtonComponent({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        if (state is RequestLoading) {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Text('Solicitando agua...'),
            ],
          );
        } else if (state is RequestSuccess) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Title(
                    color: Colors.green,
                    title: 'Pediste AGUA',
                    child: Text('''
              Estas pidiendo agua por 10Minutos a tu actual ubicacion.
              Luego de eso debera volver a pedir un aguatero nuevamente.
              '''),
                  ),
                  OutlinedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                      overlayColor: WidgetStateProperty.all(Colors.redAccent),
                    ),
                    onPressed: () {
                      BlocProvider.of<RequestBloc>(context)
                          .add(RequestCancelled());
                    },
                    label: const Text('Cancelar pedido ahora'),
                    icon: const Icon(Icons.cancel),
                  ),
                ],
              ),
            ),
          );
        } else if (state is RequestFailure) {
          return Text('Error: ${state.error}');
        } else {
          return ElevatedButton.icon(
            icon: const Icon(Icons.my_location_outlined),
            label: const Text('Pedir AGUATERO\na mi ubicación actual'),
            onPressed: () {
              BlocProvider.of<RequestBloc>(context).add(RequestStarted(
                latitude: latitude,
                longitude: longitude,
              ));
            },
          );
        }
      },
    );
  }
}
