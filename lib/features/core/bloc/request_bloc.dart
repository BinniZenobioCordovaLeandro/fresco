import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:myapp/features/core/interfaces/abstract.repository.dart';
import 'package:myapp/features/core/models/request.model.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final AbstractRepository repository;

  RequestBloc(this.repository) : super(RequestInitial()) {
    on<RequestEvent>((RequestEvent event, emit) async {
      if (event is InitialRequest) {
        var data = await repository.getAll();
        var models = List<RequestModel>.from(
          data.map((e) => RequestModel.fromMap(e)),
        );
        emit(ListRequestSuccess(models));

        Position position = await Geolocator.getCurrentPosition();
        emit(PositionSuccess(position.latitude, position.longitude));

        Stream<Position> stream = Geolocator.getPositionStream();
        stream.listen((Position position) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            emit(PositionSuccess(position.latitude, position.longitude));
          });
        });
      } else if (event is RequestStarted) {
        emit(RequestLoading());
        double latitude = event.latitude;
        double longitude = event.longitude;
        var body = RequestModel(
          latitude: latitude,
          longitude: longitude,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          status: "pending",
        ).toMap();
        try {
          var data = await repository.create(body);
          RequestModel model = RequestModel.fromMap(data);
          emit(RequestSuccess("Data received"));
        } catch (e) {
          emit(RequestFailure("Error $e"));
        }
      } else if (event is RequestCancelled) {
        try {
          emit(RequestLoading());
          await repository.delete("abc");
          emit(RequestSuccess("Request cancelled"));
        } catch (e) {
          emit(RequestFailure("Error $e"));
        }
        emit(RequestInitial());
      }
    });
  }
}
