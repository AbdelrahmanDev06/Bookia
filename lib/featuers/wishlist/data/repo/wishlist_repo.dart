import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';

class WishlistRepo {
  static const String _baseUrl = 'https://codingarabic.eraapro.com/api';

  static Future<List<ProductModel>?> getWishlist() async {
    try {
      final response = await DioProvider.get('$_baseUrl/wishlist');
      return _parse(response.data);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> addToWishlist(int productId) async {
    try {
      await DioProvider.post(
        '$_baseUrl/add-to-wishlist',
        body: {'product_id': productId},
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> removeFromWishlist(int productId) async {
    try {
      await DioProvider.post(
        '$_baseUrl/remove-from-wishlist',
        body: {'product_id': productId},
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // response: { data: [ {id, name, price, category_name, image} ] }
  // (some versions wrap it: { data: { data: [...] } })
  static List<ProductModel> _parse(dynamic json) {
    if (json is! Map) return [];
    var data = json['data'];
    if (data is Map) data = data['data'] ?? data['products'];
    if (data is! List) return [];

    return data.whereType<Map>().map((e) {
      final map = Map<String, dynamic>.from(e);
      map['category'] ??= map['category_name'];
      map['price_after_discount'] ??= map['price'];
      return ProductModel.fromJson(map);
    }).toList();
  }
}
