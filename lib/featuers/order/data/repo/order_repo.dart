import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/core/errors/safe_api_call.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/auth/data/repo/auth_repo.dart';
import 'package:bookia_app/featuers/order/data/models/order_models.dart';
import 'package:dartz/dartz.dart';

class OrderRepo {
  static List<GovernorateModel>? _governoratesCache;

  static Future<Either<Failure, List<GovernorateModel>>> getGovernorates() {
    final cached = _governoratesCache;
    if (cached != null) return Future.value(Right(cached));
    return safeApiCall(() async {
      final response = await DioProvider.get('/governorates');
      final list = GovernorateModel.listFromResponse(response.data);
      if (list.isNotEmpty) _governoratesCache = list;
      return list;
    });
  }

  static Future<Either<Failure, String>> placeOrder({
    required int governorateId,
    required String name,
    required String phone,
    required String address,
    required String email,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/place-order',
        body: {
          'governorate_id': governorateId,
          'name': name,
          'phone': phone,
          'address': address,
          'email': email,
        },
      );
      return messageOf(response.data) ?? 'Order placed successfully';
    });
  }

  static Future<Either<Failure, OrdersPage>> getOrders({int page = 1}) {
    return safeApiCall(() async {
      final response = await DioProvider.get(
        '/order-history',
        query: {'page': page},
      );
      return OrdersPage.fromResponse(response.data);
    });
  }

  static Future<Either<Failure, OrderDetailsModel>> getOrder(int id) {
    return safeApiCall(() async {
      final response = await DioProvider.get('/order-history/$id');
      final order = OrderDetailsModel.fromResponse(response.data);
      if (order == null) throw const Failure('Failed to load order details');
      return order;
    });
  }
}
