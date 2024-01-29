import 'package:equatable/equatable.dart';

abstract class InternetState {
  const InternetState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class InternetInitial extends InternetState {}

class InternetLoading extends InternetState {}

class InternetFailure extends InternetState {
  final String error;
  const InternetFailure(this.error);
}

class InternetSucess extends InternetState {
  String? success;
  InternetSucess(this.success);
}
