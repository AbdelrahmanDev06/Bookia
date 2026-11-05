import 'package:bookia_app/core/utils/price_formatter.dart';

class CartModel {
  final int id;
  final double total;
  final List<CartItemModel> items;

  CartModel({required this.id, required this.total, required this.items});

  factory CartModel.empty() => CartModel(id: 0, total: 0, items: []);

  // response: { data: { id, user, total, cart_items: [...] }, message, status }
  static CartModel fromResponse(dynamic json) {
    final data = json is Map ? json['data'] : null;
    if (data is! Map) return CartModel.empty();

    final items = data['cart_items'];
    return CartModel(
      id: parseInt(data['id']),
      total: parseDouble(data['total']),
      items: items is List
          ? items
              .whereType<Map>()
              .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }
}

class CartItemModel {
  final int itemId;
  final int productId;
  final String name;
  final String image;
  final double price;
  final int discount;
  final double priceAfterDiscount;
  final int stock;
  final int quantity;
  final double itemTotal;

  CartItemModel({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
    required this.stock,
    required this.quantity,
    required this.itemTotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        itemId: parseInt(json['item_id']),
        productId: parseInt(json['item_product_id']),
        name: json['item_product_name']?.toString() ?? '',
        image: json['item_product_image']?.toString() ?? '',
        price: parseDouble(json['item_product_price']),
        discount: parseInt(json['item_product_discount']),
        priceAfterDiscount:
            parseDouble(json['item_product_price_after_discount']),
        stock: parseInt(json['item_product_stock']),
        quantity: parseInt(json['item_quantity']),
        itemTotal: parseDouble(json['item_total']),
      );
}
