import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../logic/calculator.dart';
import '../logic/currency.dart';
import 'screens/calculator_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/home_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/result_screen.dart';

/// Схема маршрутов приложения.
///
/// /                     — главная с кнопками перехода
/// /calculator           — форма калькулятора
/// /calculator/result    — результат; данные только из query-параметров
/// /converter            — форма конвертера
/// /converter/result     — результат; данные только из query-параметров
/// всё остальное         — экран 404 через errorBuilder
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/calculator',
      builder: (context, state) => const CalculatorScreen(),
      routes: [
        // Вложенный маршрут: итоговый адрес — /calculator/result
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            final result = calculate(q['a'], q['op'], q['b']);
            final expression =
                '${q['a'] ?? '—'} ${q['op'] ?? '?'} ${q['b'] ?? '—'}';
            return switch (result) {
              CalcSuccess(value: final v) => ResultScreen(
                  title: 'Результат вычисления',
                  expression: expression,
                  resultLine: '= ${formatNumber(v)}',
                  isError: false,
                  backPath: '/calculator',
                  queryParams: q,
                ),
              CalcFailure(message: final m) => ResultScreen(
                  title: 'Результат вычисления',
                  expression: expression,
                  resultLine: 'Ошибка: $m',
                  isError: true,
                  backPath: '/calculator',
                  queryParams: q,
                ),
            };
          },
        ),
      ],
    ),
    GoRoute(
      path: '/converter',
      builder: (context, state) => const ConverterScreen(),
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            final result = convert(
              rawFrom: q['from'],
              rawTo: q['to'],
              rawAmount: q['amount'],
            );
            final expression =
                '${q['amount'] ?? '—'} ${q['from'] ?? '?'} → ${q['to'] ?? '?'}';
            return switch (result) {
              ConvertSuccess(value: final v) => ResultScreen(
                  title: 'Результат конвертации',
                  expression: expression,
                  resultLine: '= ${formatNumber(v, 2)} ${q['to'] ?? ''}'.trim(),
                  isError: false,
                  backPath: '/converter',
                  queryParams: q,
                ),
              ConvertFailure(message: final m) => ResultScreen(
                  title: 'Результат конвертации',
                  expression: expression,
                  resultLine: 'Ошибка: $m',
                  isError: true,
                  backPath: '/converter',
                  queryParams: q,
                ),
            };
          },
        ),
      ],
    ),
  ],
  // Аналог страницы 404: сюда попадают все неизвестные адреса,
  // например /qwerty.
  errorBuilder: (context, state) =>
      NotFoundScreen(location: state.uri.toString()),
);
