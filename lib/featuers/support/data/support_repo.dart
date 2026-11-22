import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/core/errors/safe_api_call.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/auth/data/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';

class FaqModel {
  final String question;
  final String answer;

  FaqModel({required this.question, required this.answer});
}

/// store contact info from `/settings`
class StoreInfo {
  final List<String> phones;
  final List<String> mails;
  final String address;
  final String bio;

  StoreInfo({
    required this.phones,
    required this.mails,
    required this.address,
    required this.bio,
  });
}

class SupportRepo {
  static Future<Either<Failure, List<FaqModel>>> getFaqs() {
    return safeApiCall(() async {
      final response = await DioProvider.get('/faqs');
      final data = response.data is Map ? response.data['data'] : null;
      final faqs = data is Map ? data['faqs'] : null;
      if (faqs is! List) return <FaqModel>[];
      return faqs
          .whereType<Map>()
          .map((e) => FaqModel(
                question: e['question']?.toString() ?? '',
                answer: e['answer']?.toString() ?? '',
              ))
          .toList();
    });
  }

  static Future<Either<Failure, StoreInfo>> getStoreInfo() {
    return safeApiCall(() async {
      final response = await DioProvider.get('/settings');
      final data = response.data is Map ? response.data['data'] : null;
      final main = data is Map ? data['main_settings'] : null;
      if (main is! Map) throw const Failure('Failed to load contact info');

      List<String> list(dynamic v) => v is List
          ? v.map((e) => '$e').where((e) => e.isNotEmpty).toList()
          : <String>[];
      final address = [main['street'], main['city'], main['country']]
          .where((e) => e != null && '$e'.isNotEmpty)
          .join(', ');

      return StoreInfo(
        phones: list(main['phones']),
        mails: list(main['mails']),
        address: address,
        bio: main['bio']?.toString() ?? '',
      );
    });
  }

  static Future<Either<Failure, String>> contactUs({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/contact-us',
        body: {
          'name': name,
          'email': email,
          'subject': subject,
          'message': message,
        },
      );
      return messageOf(response.data) ?? 'Message sent successfully';
    });
  }
}
