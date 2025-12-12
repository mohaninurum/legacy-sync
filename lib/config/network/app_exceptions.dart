import 'package:equatable/equatable.dart';

class AppException extends Equatable implements Exception {
  // ignore: prefer_typing_uninitialized_variables
  final String? message;
  final int? errorCode;

  final dynamic prefix;

  const AppException([this.message,this.errorCode, this.prefix]);

  @override
  String toString() {
    return '$message$errorCode$prefix';
  }

  @override
  List<Object?> get props => [message,errorCode, prefix];
}

class FetchDataException extends AppException {
  const FetchDataException([String? message,int? errorCode])
    : super(message,errorCode,'Error During Communication');
}

class InternalServerException extends AppException {
  const InternalServerException([String? message,int? errorCode, dynamic status])
    : super(message,errorCode, 'Internal server error [500]');
}

class BadRequestException extends AppException {
  const BadRequestException([String? message,int? errorCode])
    : super(message,errorCode, 'Invalid request [400]');
}

class UnauthorisedException extends AppException {
  const UnauthorisedException([String? message,int? errorCode])
    : super(message,errorCode, 'Unauthorised request [401]');
}

class NotFoundException extends AppException {
  const NotFoundException([String? message,int? errorCode])
    : super(message,errorCode, 'Invalid request [404]');
}

class InvalidInputException extends AppException {
  const InvalidInputException([String? message,int? errorCode])
    : super(message,errorCode, 'Invalid Input');
}

class NoInternetException extends AppException {
  const NoInternetException([String? message,int? errorCode])
    : super(message,errorCode, 'Communication issue');
}

class APIException extends Equatable implements Exception {
  const APIException({required this.message,required this.errorCode, required this.statusCode});
  final String message;
  final int errorCode;
  final dynamic statusCode;

  @override
  List<Object?> get props => [message,errorCode, statusCode];
}

class ServerException extends Equatable implements Exception {
  const ServerException({required this.message,required this.errorCode, required this.statusCode});
  final String message;
  final int errorCode;
  final dynamic statusCode;

  @override
  List<Object?> get props => [message, errorCode,statusCode];
}

class CacheException extends Equatable implements Exception {
  const CacheException({required this.message,required this.errorCode});
  final String message;
  final int errorCode;

  @override
  List<Object?> get props => [message,errorCode];
}
