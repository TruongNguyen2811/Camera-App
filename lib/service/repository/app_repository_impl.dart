import 'dart:io';

import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/service/api/api_result.dart';
import 'package:app_camera/service/api/app_api.dart';
import 'package:app_camera/service/api/app_client.dart';
import 'package:app_camera/service/app_preferences/app_preferences.dart';
import 'package:app_camera/service/repository/app_repository.dart';
import 'package:app_camera/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppRepository extends BaseRepository {
  Future<ApiResult<dynamic>> uploadImage(List<ImageData> data) async {
    try {
      logger.d('aaaaaa');
      final dynamic response =
          await appClient.uploadImage(convertImageDataListToFormData(data));
      logger.d(convertImageDataListToFormData(data));
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }
}

AppApi appClient = AppClient().appClient;
Link link = AppClient().link;
Dio dio = AppClient().dio;
