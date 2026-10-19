class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
}

class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? address;
  final String? city;
  final String? phone;
  final bool emailVerified;
  final String? image;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.address,
    this.city,
    this.phone,
    this.emailVerified = false,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        address: json['address'],
        city: json['city'],
        phone: json['phone'],
        emailVerified: json['email_verified'] == true,
        image: json['image'],
      );
}

class AuthResponse {
  final String? token;
  final UserModel? user;
  final String? message;

  AuthResponse({this.token, this.user, this.message});

  // الـ response: { data: { user: {...}, token: "..." }, message, status }
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AuthResponse(
      message: json['message']?.toString(),
      token: data is Map ? data['token']?.toString() : null,
      user: data is Map && data['user'] is Map
          ? UserModel.fromJson(Map<String, dynamic>.from(data['user']))
          : null,
    );
  }
}
