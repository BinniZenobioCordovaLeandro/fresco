part of 'request_bloc.dart';

@immutable
sealed class RequestEvent {}

final class RequestStarted extends RequestEvent {
  final double latitude;
  final double longitude;

  RequestStarted({
    required this.latitude,
    required this.longitude,
  });
}

final class RequestDataReceived extends RequestEvent {
  final String identifier;

  RequestDataReceived(this.identifier);
}

final class RequestErrorReceived extends RequestEvent {
  final String error;

  RequestErrorReceived(this.error);
}

final class RequestCancelled extends RequestEvent {}
