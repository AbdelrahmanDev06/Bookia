import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/cart/data/models/cart_model.dart';

class CartRepo {
  static const String _baseUrl = 'https://codingarabic.eraapro.com/api';

  static Future<CartModel?> getCart() async {
    try {
      final response = await DioProvider.get('$_baseUrl/cart');
      return CartModel.fromResponse(response.data);
    } catch (_) {
      return null;
    }
  }

  static Future<CartModel?> addToCart(int productId) async {
    try {
      final response = await DioProvider.post(
        '$_baseUrl/add-to-cart',
        body: {'product_id': productId},
      );
      return CartModel.fromResponse(response.data);
    } catch (_) {
      return null;
    }
  }

  static Future<CartModel?> updateCart({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await DioProvider.post(
        '$_baseUrl/update-cart',
        body: {'cart_item_id': cartItemId, 'quantity': quantity},
      );
      return CartModel.fromResponse(response.data);
    } catch (_) {
      return null;
    }
  }

  static Future<CartModel?> removeFromCart(int cartItemId) async {
    try {
      final response = await DioProvider.post(
        '$_baseUrl/remove-from-cart',
        body: {'cart_item_id': cartItemId},
      );
      return CartModel.fromResponse(response.data);
    } catch (_) {
      return null;
    }
  }
}
