import 'package:equatable/equatable.dart';

abstract class ReceiveImageState {
  const ReceiveImageState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class ReceiveInitial extends ReceiveImageState {}

class ReceiveLoading extends ReceiveImageState {}

class ReceiveFailure extends ReceiveImageState {
  final String error;
  const ReceiveFailure(this.error);
}

class ReceiveSuccess extends ReceiveImageState {
  final String error;
  const ReceiveSuccess(this.error);
}

class ConfirmSuccess extends ReceiveImageState {
  final String error;
  const ConfirmSuccess(this.error);
}

class ConfirmFailure extends ReceiveImageState {
  final String error;
  const ConfirmFailure(this.error);
}

class ConvertSuccess extends ReceiveImageState {}
