import 'package:app_camera/model/confirm_image.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'app_api.g.dart';

@RestApi()
abstract class AppApi {
  factory AppApi(Dio dio, {String baseUrl}) = _AppApi;

  @POST('/ocr-images')
  Future<dynamic> uploadImage(
    @Body() FormData request,
  );

  @POST('/ocr-image-confirmation')
  Future<dynamic> confirmImage(
    @Body() ConfrimImage request,
  );
}
