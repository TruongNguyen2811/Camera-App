import 'package:equatable/equatable.dart';

abstract class AllImageState {
  const AllImageState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class AllImageInitial extends AllImageState {}

class AllImageLoading extends AllImageState {}

class AllImageFailure extends AllImageState {
  final String error;
  const AllImageFailure(this.error);
}

class AllImageSuccess extends AllImageState {
  const AllImageSuccess();
}

class ImageDeleteSuccess extends AllImageState {
  const ImageDeleteSuccess();
}

class ListImageEmpty extends AllImageState {}

class DeleteImage extends AllImageState {
  final String message;
  const DeleteImage(this.message);
}

class UploadImageSuccess extends AllImageState {
  final String message;
  const UploadImageSuccess(this.message);
}

class selectAllSuccess extends AllImageState {}

class AllImagePaging extends AllImageState {}
