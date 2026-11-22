import 'package:bookia_app/core/utils/price_formatter.dart';

class GovernorateModel {
  final int id;
  final String name;

  GovernorateModel({required this.id, required this.name});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      GovernorateModel(
        id: parseInt(json['id']),
        name: (json['governorate_name_en'] ?? json['governorate_name_ar'] ?? '')
            .toString(),
      );

  // response: { data: [ { id, governorate_name_en } ] }
  static List<GovernorateModel> listFromResponse(dynamic json) {
    final data = json is Map ? json['data'] : null;
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => GovernorateModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

/// one row in the order history list
class OrderSummaryModel {
  final int id;
  final String code;
  final String date;
  final String status;
  final double total;

  OrderSummaryModel({
    required this.id,
    required this.code,
    required this.date,
    required this.status,
    required this.total,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) =>
      OrderSummaryModel(
        id: parseInt(json['id']),
        code: json['order_code']?.toString() ?? '',
        date: json['order_date']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        total: parseDouble(json['total']),
      );
}

class OrdersPage {
  final List<OrderSummaryModel> orders;
  final int currentPage;
  final int lastPage;

  OrdersPage({
    required this.orders,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasMore => currentPage < lastPage;

  // response: { data: { orders: [...], meta: { current_page, last_page } } }
  factory OrdersPage.fromResponse(dynamic json) {
    final data = json is Map ? json['data'] : null;
    final orders = data is Map ? data['orders'] : null;
    final meta = data is Map ? data['meta'] : null;
    return OrdersPage(
      orders: orders is List
          ? orders
              .whereType<Map>()
              .map((e) => OrderSummaryModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
      currentPage: meta is Map ? parseInt(meta['current_page']) : 1,
      lastPage: meta is Map ? parseInt(meta['last_page']) : 1,
    );
  }
}

class OrderDetailsModel {
  final int id;
  final String code;
  final String date;
  final String status;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String governorate;
  final String notes;
  final double subTotal;
  final double discount;
  final double total;
  final List<OrderProductModel> products;

  OrderDetailsModel({
    required this.id,
    required this.code,
    required this.date,
    required this.status,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.governorate,
    required this.notes,
    required this.subTotal,
    required this.discount,
    required this.total,
    required this.products,
  });

  static OrderDetailsModel? fromResponse(dynamic json) {
    final data = json is Map ? json['data'] : null;
    if (data is! Map) return null;
    final products = data['order_products'];
    String str(String key) => data[key]?.toString() ?? '';
    return OrderDetailsModel(
      id: parseInt(data['id']),
      code: str('order_code'),
      date: str('order_date'),
      status: str('status'),
      name: str('name'),
      email: str('email'),
      phone: str('phone'),
      address: str('address'),
      governorate: str('governorate'),
      notes: str('notes'),
      subTotal: parseDouble(data['sub_total']),
      discount: parseDouble(data['discount']),
      total: parseDouble(data['total']),
      products: products is List
          ? products
              .whereType<Map>()
              .map((e) => OrderProductModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }
}

class OrderProductModel {
  final int productId;
  final String name;
  final double price;
  final double priceAfterDiscount;
  final int quantity;
  final double total;

  OrderProductModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.priceAfterDiscount,
    required this.quantity,
    required this.total,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      OrderProductModel(
        productId: parseInt(json['product_id']),
        name: json['product_name']?.toString() ?? '',
        price: parseDouble(json['product_price']),
        priceAfterDiscount: parseDouble(json['product_price_after_discount']),
        quantity: parseInt(json['order_product_quantity']),
        total: parseDouble(json['product_total']),
      );
}
