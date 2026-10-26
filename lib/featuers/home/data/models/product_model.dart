class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int discount;
  final double priceAfterDiscount;
  final int stock;
  final int bestSeller;
  final String image;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
    required this.stock,
    required this.bestSeller,
    required this.image,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: _toInt(json['id']),
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        price: _toDouble(json['price']),
        discount: _toInt(json['discount']),
        priceAfterDiscount: _toDouble(json['price_after_discount']),
        stock: _toInt(json['stock']),
        bestSeller: _toInt(json['best_seller']),
        image: json['image']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
      );

  static List<ProductModel> listFromResponse(Map<String, dynamic> json) {
    final data = json['data'];
    final products = data is Map ? data['products'] : null;
    if (products is! List) return [];
    return products
        .whereType<Map>()
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  String get formattedPrice => priceAfterDiscount % 1 == 0
      ? priceAfterDiscount.toInt().toString()
      : priceAfterDiscount.toStringAsFixed(2);
}

double _toDouble(dynamic value) => double.tryParse('${value ?? ''}') ?? 0;

int _toInt(dynamic value) => _toDouble(value).toInt();
