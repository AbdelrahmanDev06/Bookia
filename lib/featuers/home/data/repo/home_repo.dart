import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/core/errors/safe_api_call.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/data/models/slider_model.dart';
import 'package:dartz/dartz.dart';

class HomeRepo {
  static const String _baseUrl = 'https://codingarabic.eraapro.com/api';

  static Future<Either<Failure, List<ProductModel>>> getBestSeller() {
    return safeApiCall(() async {
      final response = await DioProvider.get('$_baseUrl/products-bestseller');
      return ProductModel.listFromResponse(
        Map<String, dynamic>.from(response.data),
      );
    });
  }

  static Future<Either<Failure, List<ProductModel>>> getProducts() {
    return safeApiCall(() async {
      final products = <ProductModel>[];
      var page = 1;
      var lastPage = 1;

      do {
        final response = await DioProvider.get(
          '$_baseUrl/products',
          query: {'page': page},
        );
        final json = Map<String, dynamic>.from(response.data);
        products.addAll(ProductModel.listFromResponse(json));
        lastPage = _lastPage(json);
        page++;
      } while (page <= lastPage);

      return products;
    });
  }

  static Future<Either<Failure, List<SliderModel>>> getSliders() {
    return safeApiCall(() async {
      final response = await DioProvider.get('$_baseUrl/sliders');
      return SliderModel.listFromResponse(
        Map<String, dynamic>.from(response.data),
      );
    });
  }

  static Future<Either<Failure, ProductModel>> getProductDetails(int id) {
    return safeApiCall(() async {
      final response = await DioProvider.get('$_baseUrl/products/$id');
      final product = ProductModel.fromDetailsResponse(
        Map<String, dynamic>.from(response.data),
      );
      if (product == null) throw const Failure('Book details not found');
      return product;
    });
  }

  static Future<Either<Failure, List<ProductModel>>> searchProducts(
    String name,
  ) {
    return safeApiCall(() async {
      final response = await DioProvider.get(
        '$_baseUrl/products-search',
        query: {'name': name},
      );
      return ProductModel.listFromResponse(
        Map<String, dynamic>.from(response.data),
      );
    });
  }

  static int _lastPage(Map<String, dynamic> json) {
    final data = json['data'];
    final meta = data is Map ? data['meta'] : null;
    if (meta is! Map) return 1;
    return int.tryParse('${meta['last_page']}') ?? 1;
  }
}
