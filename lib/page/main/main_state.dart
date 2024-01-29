import 'package:equatable/equatable.dart';

abstract class MainState {
  const MainState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainFailure extends MainState {
  final String error;
  const MainFailure(this.error);
}

class MainSucess extends MainState {
  String? success;
  MainSucess(this.success);
}
