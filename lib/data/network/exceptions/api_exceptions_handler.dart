import 'package:dio/dio.dart';

import 'api_exceptions.dart';

class ApiExceptionHandler {
  final DioError _dioError;

  const ApiExceptionHandler(this._dioError);

  ApiException get exception {
    switch (_dioError.response!.statusCode) {
      case 400:
        return BadRequestException(_dioError);
      case 401:
        return UnauthorisedException(_dioError);
      case 403:
        return UnauthorisedException(_dioError);
      case 404:
        return ResourceNotFound(_dioError);
      case 409:
        return ConflictException(_dioError);
      default:
        return FetchDataException(_dioError);
    }
  }
}
