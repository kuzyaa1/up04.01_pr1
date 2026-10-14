import 'package:calc_web/logic/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculate', () {
    test('сложение', () {
      final r = calculate('2', '+', '3');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).value, 5);
    });

    test('вычитание', () {
      final r = calculate('10', '-', '4');
      expect((r as CalcSuccess).value, 6);
    });

    test('умножение', () {
      final r = calculate('3', '*', '7');
      expect((r as CalcSuccess).value, 21);
    });

    test('деление', () {
      final r = calculate('8', '/', '2');
      expect((r as CalcSuccess).value, 4);
    });

    test('деление на ноль — ошибка, а не исключение', () {
      final r = calculate('5', '/', '0');
      expect(r, isA<CalcFailure>());
      expect((r as CalcFailure).message, contains('ноль'));
    });

    test('нечисловой ввод — ошибка', () {
      final r = calculate('abc', '+', '2');
      expect(r, isA<CalcFailure>());
    });

    test('отсутствие параметра — ошибка', () {
      expect(calculate(null, '+', '2'), isA<CalcFailure>());
      expect(calculate('2', null, '2'), isA<CalcFailure>());
      expect(calculate('2', '+', null), isA<CalcFailure>());
    });

    test('неизвестная операция — ошибка', () {
      final r = calculate('2', '%', '3');
      expect(r, isA<CalcFailure>());
      expect((r as CalcFailure).message, contains('операция'));
    });

    test('запятая как десятичный разделитель', () {
      final r = calculate('2,5', '+', '2,5');
      expect((r as CalcSuccess).value, 5);
    });
  });
}
