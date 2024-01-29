import 'package:equatable/equatable.dart';

abstract class HomeState {
  const HomeState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeFailure extends HomeState {
  final String error;
  const HomeFailure(this.error);
}

class HomeGetSessionIdSucess extends HomeState {
  final String error;
  const HomeGetSessionIdSucess(this.error);
}
