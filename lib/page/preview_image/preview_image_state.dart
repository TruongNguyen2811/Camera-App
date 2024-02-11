import 'package:equatable/equatable.dart';

abstract class PreviewImageState {
  const PreviewImageState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class PreviewInitial extends PreviewImageState {}

class PreviewLoading extends PreviewImageState {}

class PreviewFailure extends PreviewImageState {
  final String error;
  const PreviewFailure(this.error);
}

class PreviewSuccess extends PreviewImageState {
  final String error;
  const PreviewSuccess(this.error);
}

class UploadFailure extends PreviewImageState {
  final String error;
  const UploadFailure(this.error);
}

class UploadInternetFailure extends PreviewImageState {
  final String error;
  const UploadInternetFailure(this.error);
}

class UploadSuccess extends PreviewImageState {
  final String error;
  const UploadSuccess(this.error);
}

class SaveSuccess extends PreviewImageState {
  final String error;
  const SaveSuccess(this.error);
}
