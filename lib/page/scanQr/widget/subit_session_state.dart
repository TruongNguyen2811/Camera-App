import 'package:equatable/equatable.dart';

abstract class SubmitSessionState {
  const SubmitSessionState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class SubmitSessionInitial extends SubmitSessionState {}

class SubmitSessionLoading extends SubmitSessionState {}

class SubmitSessionFailure extends SubmitSessionState {
  final String error;
  const SubmitSessionFailure(this.error);
}

class SubmitSessionStart extends SubmitSessionState {
  SubmitSessionStart();
}

class SubmitSessionSucess extends SubmitSessionState {
  String? success;
  SubmitSessionSucess(this.success);
}
