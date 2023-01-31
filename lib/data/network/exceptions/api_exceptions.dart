import 'package:dio/dio.dart';

class ApiException implements DioError {
  final String messageLT;

  @override
  final String message;

  @override
  late final dynamic error;

  @override
  late final RequestOptions requestOptions;

  @override
  late final Response? response;

  @override
  late final StackTrace? stackTrace;

  @override
  late final DioErrorType type;

  ApiException(DioError dioError, this.message, this.messageLT) {
    error = dioError.error;
    requestOptions = dioError.requestOptions;
    response = dioError.response;
    stackTrace = dioError.stackTrace;
    type = dioError.type;
  }

  @override
  String toString() {
    return message;
  }
}

class FetchDataException extends ApiException {
  FetchDataException(DioError dioError)
      : super(
          dioError,
          'Įvyko klaida bandant susisieti su serveriu',
          'An error occured while connecting to a server',
        );
}

class BadRequestException extends ApiException {
  BadRequestException(DioError dioError)
      : super(
          dioError,
          'Klaidingas kreipimasis į serverį',
          'Bad request',
        );
}

class UnauthorisedException extends ApiException {
  UnauthorisedException(DioError dioError)
      : super(
          dioError,
          'Klaida. Vartotojas neautentifikuotas',
          'User is not authenticated',
        );
}

class ResourceNotFound extends ApiException {
  ResourceNotFound(DioError dioError)
      : super(
          dioError,
          'Rezultatų nėra',
          'Results not found',
        );
}

class ConflictException extends ApiException {
  ConflictException(DioError dioError)
      : super(
          dioError,
          'Vartotojas su tokiu el. paštu jau priregistruotas',
          'User with this email is already registered',
        );
}
