import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'state/theme_notifier.dart';

void main() {
  // /calculator вместо /#/calculator
  usePathUrlStrategy();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const CalcApp(),
    ),
  );
}

class CalcApp extends StatelessWidget {
  const CalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    return MaterialApp.router(
      title: 'Калькулятор и конвертер',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: theme.mode,
      routerConfig: appRouter,
      builder: (context, child) {
        return Scaffold(
          body: child ?? const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.read<ThemeNotifier>().toggle(),
            label: Text(theme.isDark ? 'Светлая тема' : 'Тёмная тема'),
          ),
        );
      },
    );
  }
}
