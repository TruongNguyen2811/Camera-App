import 'package:equatable/equatable.dart';

abstract class ListImageState {
  const ListImageState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class ListImageInitial extends ListImageState {}

class ListImageLoading extends ListImageState {}

class ListImageFailure extends ListImageState {
  final String error;
  const ListImageFailure(this.error);
}

class ListImageSuccess extends ListImageState {
  final String error;
  const ListImageSuccess(this.error);
}
