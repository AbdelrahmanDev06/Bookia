import 'package:dio/dio.dart';

class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});

  factory ServerFailure.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure('Connection timeout, please try again');
      case DioExceptionType.sendTimeout:
        return const ServerFailure('Send timeout, please try again');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Receive timeout, please try again');
      case DioExceptionType.badCertificate:
        return const ServerFailure('Bad certificate, connection is not secure');
      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled');
      case DioExceptionType.connectionError:
        return const ServerFailure('No internet connection');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          e.response?.statusCode,
          e.response?.data,
        );
      default:
        return const ServerFailure('Unexpected error, please try again');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic data) {
    final serverMessage = _extractMessage(data);

    switch (statusCode) {
      case 400:
      case 422:
        return ServerFailure(
          serverMessage ?? 'Invalid data, please check your inputs',
          statusCode: statusCode,
        );
      case 401:
        return ServerFailure(
          serverMessage ?? 'Unauthorized, please login again',
          statusCode: statusCode,
        );
      case 403:
        return ServerFailure(
          serverMessage ?? 'You are not allowed to do this',
          statusCode: statusCode,
        );
      case 404:
        return ServerFailure(
          serverMessage ?? 'Not found',
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
        return ServerFailure(
          'Server error, please try again later',
          statusCode: statusCode,
        );
      default:
        return ServerFailure(
          serverMessage ?? 'Something went wrong, please try again',
          statusCode: statusCode,
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is! Map) return null;

    for (final key in ['errors', 'error']) {
      final errors = data[key];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        if (first != null) return first.toString();
      }
      if (errors is String && errors.isNotEmpty) return errors;
    }

    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
    return null;
  }
}
