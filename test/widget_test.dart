import 'package:bookia_app/core/utils/app_validator.dart';
import 'package:bookia_app/featuers/order/data/models/order_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidator', () {
    test('email', () {
      expect(AppValidator.email(''), isNotNull);
      expect(AppValidator.email('bad'), isNotNull);
      expect(AppValidator.email('a@b.co'), isNull);
    });

    test('password and confirm', () {
      expect(AppValidator.password('1234567'), isNotNull);
      expect(AppValidator.password('12345678'), isNull);
      final confirm = AppValidator.confirm(() => '12345678');
      expect(confirm('12345679'), isNotNull);
      expect(confirm('12345678'), isNull);
    });

    test('phone', () {
      expect(AppValidator.phone('abc'), isNotNull);
      expect(AppValidator.phone('01012345678'), isNull);
    });
  });

  group('Order models', () {
    test('parses order history page', () {
      final page = OrdersPage.fromResponse({
        'data': {
          'orders': [
            {
              'id': 51,
              'order_code': '00051',
              'order_date': '2023-08-14',
              'status': 'New',
              'total': '130.51',
            },
          ],
          'meta': {'current_page': 1, 'last_page': 2},
        },
      });
      expect(page.orders.single.id, 51);
      expect(page.orders.single.total, 130.51);
      expect(page.hasMore, isTrue);
    });

    test('parses order details', () {
      final order = OrderDetailsModel.fromResponse({
        'data': {
          'id': 52,
          'order_code': '00052',
          'total': '594.03',
          'sub_total': '594.03',
          'discount': 0,
          'notes': null,
          'order_products': [
            {
              'product_id': 2,
              'product_name': 'doloremque',
              'product_price': '421.00',
              'product_price_after_discount': 130.51,
              'order_product_quantity': 3,
              'product_total': '391.53',
            },
          ],
        },
      })!;
      expect(order.total, 594.03);
      expect(order.notes, '');
      expect(order.products.single.quantity, 3);
    });

    test('parses governorates', () {
      final list = GovernorateModel.listFromResponse({
        'data': [
          {'id': 1, 'governorate_name_en': 'Cairo'},
        ],
      });
      expect(list.single.name, 'Cairo');
    });
  });
}
