import 'package:calc_web/core/format.dart';
import 'package:calc_web/logic/currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('convert', () {
    test('доллары в рубли', () {
      final r = convert(rawFrom: 'USD', rawTo: 'RUB', rawAmount: '100');
      expect(r, isA<ConvertSuccess>());
      expect((r as ConvertSuccess).value, 8000);
    });

    test('рубли в доллары', () {
      final r = convert(rawFrom: 'RUB', rawTo: 'USD', rawAmount: '80');
      expect((r as ConvertSuccess).value, closeTo(1, 1e-9));
    });

    test('кросс-курс евро в юани', () {
      final r = convert(rawFrom: 'EUR', rawTo: 'CNY', rawAmount: '1');
      expect((r as ConvertSuccess).value, closeTo(92 / 11, 1e-9));
    });

    test('нечисловая сумма — ошибка', () {
      expect(
        convert(rawFrom: 'USD', rawTo: 'RUB', rawAmount: 'abc'),
        isA<ConvertFailure>(),
      );
    });

    test('отсутствие суммы — ошибка', () {
      expect(
        convert(rawFrom: 'USD', rawTo: 'RUB', rawAmount: null),
        isA<ConvertFailure>(),
      );
    });

    test('неизвестная валюта — ошибка', () {
      expect(
        convert(rawFrom: 'XXX', rawTo: 'RUB', rawAmount: '10'),
        isA<ConvertFailure>(),
      );
    });

    test('отрицательная сумма — ошибка', () {
      final r = convert(rawFrom: 'USD', rawTo: 'RUB', rawAmount: '-5');
      expect(r, isA<ConvertFailure>());
    });
  });

  group('formatNumber', () {
    test('убирает бесконечную дробь 10/3', () {
      expect(formatNumber(10 / 3), isNot('3.3333333333333335'));
      expect(formatNumber(10 / 3), '3.333333');
    });

    test('целое без дробной части', () {
      expect(formatNumber(8), '8');
    });

    test('убирает хвостовые нули', () {
      expect(formatNumber(2.5), '2.5');
    });
  });
}
