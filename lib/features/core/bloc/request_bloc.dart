import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:myapp/features/core/models/request.model.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestInitial()) {
    on<RequestEvent>((RequestEvent event, emit) async {
      if (event is RequestStarted) {
        emit(RequestLoading());

        double latitude = event.latitude;
        double longitude = event.longitude;

        // create new service request to point
        await Future.delayed(const Duration(seconds: 2));
        if (1 == 1) {
          emit(RequestSuccess("Data received"));
        } else {
          emit(RequestFailure("Error"));
        }
      } else if (event is RequestCancelled) {
        emit(RequestInitial());
      }
    });
  }
}
