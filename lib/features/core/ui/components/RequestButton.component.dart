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
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.red),
            ),
            onPressed: () {
              BlocProvider.of<RequestBloc>(context).add(RequestCancelled());
            },
            child: const Text('Cancelar solicitud'),
          );
        } else if (state is RequestFailure) {
          return Text('Error: ${state.error}');
        } else {
          return ElevatedButton(
            onPressed: () {
              BlocProvider.of<RequestBloc>(context).add(RequestStarted(
                latitude: latitude,
                longitude: longitude,
              ));
            },
            child: const Text('Solicitar agua'),
          );
        }
      },
    );
  }
}
