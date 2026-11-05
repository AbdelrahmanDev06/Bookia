import 'package:bookia_app/core/utils/price_formatter.dart';

class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String address;
  final String city;
  final String phone;
  final String image;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.city,
    required this.phone,
    required this.image,
  });

  // response: { data: { id, name, email, address, city, phone, image } }
  static ProfileModel? fromResponse(dynamic json) {
    final data = json is Map ? json['data'] : null;
    if (data is! Map) return null;
    return ProfileModel(
      id: parseInt(data['id']),
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      city: data['city']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
    );
  }

  /// the API returns ".../storage" when the user has no photo
  bool get hasImage => image.isNotEmpty && !image.endsWith('/storage');
}
