import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/data/models/slider_model.dart';

class HomeRepo {
  static const String _baseUrl = 'https://codingarabic.eraapro.com/api';

  static Future<List<ProductModel>?> getBestSeller() async {
    try {
      final response = await DioProvider.get('$_baseUrl/products-bestseller');
      return ProductModel.listFromResponse(
        Map<String, dynamic>.from(response.data),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<List<ProductModel>?> getProducts() async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<List<SliderModel>?> getSliders() async {
    try {
      final response = await DioProvider.get('$_baseUrl/sliders');
      return SliderModel.listFromResponse(
        Map<String, dynamic>.from(response.data),
      );
    } catch (_) {
      return null;
    }
  }

  static int _lastPage(Map<String, dynamic> json) {
    final data = json['data'];
    final meta = data is Map ? data['meta'] : null;
    if (meta is! Map) return 1;
    return int.tryParse('${meta['last_page']}') ?? 1;
  }
}
