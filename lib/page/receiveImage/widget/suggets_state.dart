import 'package:equatable/equatable.dart';

abstract class SuggestTextState {
  const SuggestTextState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class SuggestTextInitial extends SuggestTextState {}

class SuggestTextLoading extends SuggestTextState {}

class SuggestTextFailure extends SuggestTextState {
  final String error;
  const SuggestTextFailure(this.error);
}

class SuggestTextStart extends SuggestTextState {
  SuggestTextStart();
}

class SuggestTextSubmit extends SuggestTextState {
  String? success;
  SuggestTextSubmit(this.success);
}
