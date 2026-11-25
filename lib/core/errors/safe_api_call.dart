import 'package:bookia_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } on DioException catch (e) {
    debugPrint('DioException: ${e.type} ${e.response?.statusCode} ${e.response?.data}');
    return Left(ServerFailure.fromDioException(e));
  } on Failure catch (e) {
    return Left(e);
  } catch (e) {
    debugPrint('Unexpected error: $e');
    return const Left(Failure('Something went wrong, please try again'));
  }
}
