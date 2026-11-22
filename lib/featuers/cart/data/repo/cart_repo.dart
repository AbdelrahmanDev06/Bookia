import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/core/errors/safe_api_call.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/cart/data/models/cart_model.dart';
import 'package:dartz/dartz.dart';

class CartRepo {

  static Future<Either<Failure, CartModel>> getCart() {
    return safeApiCall(() async {
      final response = await DioProvider.get('/cart');
      return CartModel.fromResponse(response.data);
    });
  }

  static Future<Either<Failure, CartModel>> addToCart(int productId) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/add-to-cart',
        body: {'product_id': productId},
      );
      return CartModel.fromResponse(response.data);
    });
  }

  static Future<Either<Failure, CartModel>> updateCart({
    required int cartItemId,
    required int quantity,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/update-cart',
        body: {'cart_item_id': cartItemId, 'quantity': quantity},
      );
      return CartModel.fromResponse(response.data);
    });
  }

  static Future<Either<Failure, CartModel>> removeFromCart(int cartItemId) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/remove-from-cart',
        body: {'cart_item_id': cartItemId},
      );
      return CartModel.fromResponse(response.data);
    });
  }
}
