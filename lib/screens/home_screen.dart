import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главная')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Калькулятор и конвертер',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Маршруты: /calculator и /converter.\n'
                  'Результат каждого расчёта живёт по своему адресу.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  // go заменяет текущий адрес (переход по ссылке),
                  // а не кладёт экран поверх — поэтому кнопка
                  // «назад» браузера работает корректно.
                  onPressed: () => context.go('/calculator'),
                  child: const Text('Калькулятор'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go('/converter'),
                  child: const Text('Конвертер валют'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
