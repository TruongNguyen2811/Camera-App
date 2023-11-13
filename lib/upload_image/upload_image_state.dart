import 'package:equatable/equatable.dart';

abstract class UploadImageState {
  const UploadImageState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class UpLoadInitial extends UploadImageState {}

class UploadLoading extends UploadImageState {}

class UpLoadFailure extends UploadImageState {
  final String error;
  const UpLoadFailure(this.error);
}

class UpLoadSuccess extends UploadImageState {
  final String error;
  const UpLoadSuccess(this.error);
}
