import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/logger.dart';
part 'network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest(String? reason) =
      UnauthorizedRequest;

  const factory NetworkExceptions.badRequest(String? reason) = BadRequest;

  const factory NetworkExceptions.notFound(String reason) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(
      String errorCode, String message, dynamic data) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  static NetworkExceptions handleResponse(dynamic data, int? statusCode) {
    String? message;
    String? errorCode;
    logger.e(data);

    if (data.toString().contains("message")) {
      message = data["message"].toString();
    }
    if (data.toString().contains("errorCode")) {
      errorCode = data["errorCode"].toString();
    }

    if (data is String) {
      message = data;
    }

    if (statusCode == 401) {
      return NetworkExceptions.unauthorizedRequest(message);
    }

    if (message!.isNotEmpty) {
      return NetworkExceptions.defaultError(
          errorCode ?? statusCode.toString(), message, data["data"]);
    }

    switch (statusCode) {
      case 400:
      case 403:
        return NetworkExceptions.badRequest(message);
      case 401:
        // case 403:
        return NetworkExceptions.unauthorizedRequest(message);
      case 404:
        return const NetworkExceptions.notFound("Not found");
      case 409:
        return const NetworkExceptions.conflict();
      case 408:
        return const NetworkExceptions.requestTimeout();
      case 500:
        return const NetworkExceptions.internalServerError();
      case 503:
        return const NetworkExceptions.serviceUnavailable();
      case 501:
        return NetworkExceptions.defaultError(
            errorCode ?? statusCode.toString(), message, data["data"]);
      default:
        return NetworkExceptions.defaultError(
            errorCode ?? statusCode.toString(), message, data["data"]);
    }
  }

  static NetworkExceptions getDioException(error) {
    NetworkExceptions networkExceptions;
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
              break;
            case DioErrorType.connectTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioErrorType.other:
              networkExceptions =
                  const NetworkExceptions.noInternetConnection();
              break;
            case DioErrorType.receiveTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioErrorType.response:
              networkExceptions = NetworkExceptions.handleResponse(
                  error.response?.data is String
                      ? json.decode(error.response?.data ?? "")
                      : error.response?.data,
                  error.response?.statusCode);
              break;
            case DioErrorType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException {
        // Helper.printError(e.toString());
        return const NetworkExceptions.formatException();
      } catch (_) {
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = "";
    networkExceptions.when(notImplemented: () {
      errorMessage = "Không được thực hiện";
    }, requestCancelled: () {
      errorMessage = "Yêu cầu đã huỷ";
    }, internalServerError: () {
      errorMessage = 'Lỗi máy chủ';
    }, notFound: (String reason) {
      errorMessage = reason;
    }, serviceUnavailable: () {
      errorMessage = 'Dịch vụ không sẵn có';
    }, methodNotAllowed: () {
      errorMessage = 'Phương thức đã cho phép';
    }, badRequest: (String? reason) {
      errorMessage = reason ?? 'Yêu cầu sai';
    }, unauthorizedRequest: (reason) {
      errorMessage = reason ?? 'Không có quyền truy cập';
    }, unexpectedError: () {
      errorMessage = 'Đã xảy ra lỗi không mong muốn';
    }, requestTimeout: () {
      errorMessage = 'Hết thời gian yêu cầu kết nối';
    }, noInternetConnection: () {
      errorMessage = 'Kết nối bị gián đoạn!';
    }, conflict: () {
      errorMessage = 'Lỗi do xung đột';
    }, sendTimeout: () {
      errorMessage = 'Hết thời gian gửi kết nối với máy chủ';
    }, unableToProcess: () {
      errorMessage = 'Không thể xử lý dữ liệu';
    }, defaultError: (String errorCode, String message, dynamic data) {
      errorMessage = message;
    }, formatException: () {
      errorMessage = 'Đã xảy ra lỗi không mong muốn';
    }, notAcceptable: () {
      errorMessage = 'Không thể chấp nhận';
    });
    return errorMessage;
  }
}
