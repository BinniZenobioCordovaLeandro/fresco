part of 'request_bloc.dart';

@immutable
sealed class RequestState {}

final class RequestInitial extends RequestState {}

final class RequestLoading extends RequestState {}

final class RequestSuccess extends RequestState {
  final String data;

  RequestSuccess(this.data);
}

final class RequestFailure extends RequestState {
  final String error;

  RequestFailure(this.error);
}
