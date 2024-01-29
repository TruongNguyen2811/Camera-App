import 'package:equatable/equatable.dart';

abstract class ScanQRState {
  const ScanQRState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class ScanQRInitial extends ScanQRState {}

class ScanQRLoading extends ScanQRState {}

class ScanQRFailure extends ScanQRState {
  final String error;
  const ScanQRFailure(this.error);
}

class ScanQRStart extends ScanQRState {
  ScanQRStart();
}

class ScanQRSucess extends ScanQRState {
  ScanQRSucess();
}
