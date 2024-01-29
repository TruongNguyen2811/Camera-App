import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/service/api/api_result.dart';
import 'package:app_camera/service/api/network_exceptions.dart';
import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

abstract class BaseRepository {
  //'count' to handle for UnauthorizedRequest with multiple api case
  // Avoid show Toast Unautherized many times.

  FormData wrapFormData<T>(T source) {
    return FormData.fromMap({
      "source": MultipartFile.fromString(jsonEncode(source),
          contentType: MediaType.parse('application/json'))
    });
  }

  FormData wrapMapFormData(Map<String, dynamic> body) {
    final Map<String, dynamic> request = body.map((key, value) => MapEntry(
        key,
        value is List<File>
            ? value.map((e) => MultipartFile.fromFileSync(e.path)).toList()
            : value is File
                ? MultipartFile.fromFile(value.path)
                : MultipartFile.fromString(jsonEncode(value),
                    contentType: MediaType.parse('application/json'))));
    return FormData.fromMap(request);
  }

  Stream<Uint8List> wrapBinary(File file) {
    final binary = file.openRead().cast<Uint8List>();
    return binary;
  }

  ApiResult<T> handleErrorApi<T>(dynamic e,
      {String tag = "", forceLogout = true}) {
    NetworkExceptions exceptions = NetworkExceptions.getDioException(e);
    if (forceLogout && exceptions is UnauthorizedRequest) {
      return const ApiResult.failure(error: NetworkExceptions.notFound(""));
    }

    return ApiResult.failure(error: exceptions);
  }

  FormData convertImageDataListToFormData(List<ImageData> imageDataList) {
    FormData formData = FormData();

    for (int i = 0; i < imageDataList.length; i++) {
      ImageData imageData = imageDataList[i];

      final Map<String, dynamic> formDataMap = {
        'createDate': imageData.createDate?.toString() ?? '',
        'name': imageData.name ?? '',
        'isDbr': imageData.isDbr?.toString() ?? 'false',
        'id': imageData.id?.toString() ?? '',
        'type': imageData.type ?? '',
      };

      if (imageData.uint8list != null) {
        formDataMap['images'] = MultipartFile.fromBytes(
          imageData.uint8list!,
          filename: imageData.name ?? 'image_file_$i',
        );
      }

      formData.fields.addAll(formDataMap.entries.map(
        (entry) => MapEntry(entry.key, entry.value.toString()),
      ));

      if (imageData.uint8list != null) {
        formData.files.add(
          MapEntry(
            'images',
            formDataMap['images'] as MultipartFile,
          ),
        );
      }
    }

    return formData;
  }
}
