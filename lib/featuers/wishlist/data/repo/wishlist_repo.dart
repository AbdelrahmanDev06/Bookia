import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/core/errors/safe_api_call.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:dartz/dartz.dart';

class WishlistRepo {

  static Future<Either<Failure, List<ProductModel>>> getWishlist() {
    return safeApiCall(() async {
      final response = await DioProvider.get('/wishlist');
      return _parse(response.data);
    });
  }

  static Future<Either<Failure, Unit>> addToWishlist(int productId) {
    return safeApiCall(() async {
      await DioProvider.post(
        '/add-to-wishlist',
        body: {'product_id': productId},
      );
      return unit;
    });
  }

  static Future<Either<Failure, Unit>> removeFromWishlist(int productId) {
    return safeApiCall(() async {
      await DioProvider.post(
        '/remove-from-wishlist',
        body: {'product_id': productId},
      );
      return unit;
    });
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
