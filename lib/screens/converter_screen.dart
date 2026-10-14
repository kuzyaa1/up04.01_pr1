import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/currency.dart';

/// Экран конвертера валют.
///
/// Запоминает последнюю выбранную пару валют в SharedPreferences
/// (на web это localStorage) и восстанавливает её при открытии.
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  static const _fromKey = 'conv_from';
  static const _toKey = 'conv_to';

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _from = 'USD';
  String _to = 'RUB';
  bool _prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _restorePair();
  }

  Future<void> _restorePair() async {
    final prefs = await SharedPreferences.getInstance();
    final from = prefs.getString(_fromKey);
    final to = prefs.getString(_toKey);
    if (!mounted) return;
    setState(() {
      if (from != null && currencies.contains(from)) _from = from;
      if (to != null && currencies.contains(to)) _to = to;
      _prefsLoaded = true;
    });
  }

  Future<void> _savePair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fromKey, _from);
    await prefs.setString(_toKey, _to);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _amountValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите сумму';
    final amount = double.tryParse(value.trim().replaceAll(',', '.'));
    if (amount == null) return 'Это не число';
    if (amount < 0) return 'Сумма не может быть отрицательной';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = _amountController.text.trim().replaceAll(',', '.');
    _savePair();
    context.go(
      '/converter/result?from=${Uri.encodeComponent(_from)}'
      '&to=${Uri.encodeComponent(_to)}'
      '&amount=${Uri.encodeComponent(amount)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Конвертер валют')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _from,
                    decoration: const InputDecoration(
                      labelText: 'Из валюты',
                      border: OutlineInputBorder(),
                    ),
                    items: currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _from = value);
                      _savePair();
                    },
                    validator: (value) =>
                        value == null ? 'Выберите валюту' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _to,
                    decoration: const InputDecoration(
                      labelText: 'В валюту',
                      border: OutlineInputBorder(),
                    ),
                    items: currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _to = value);
                      _savePair();
                    },
                    validator: (value) =>
                        value == null ? 'Выберите валюту' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Сумма',
                      border: OutlineInputBorder(),
                    ),
                    validator: _amountValidator,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _prefsLoaded
                        ? 'Пара $_from → $_to запомнена и восстановится '
                            'при следующем открытии.'
                        : 'Загрузка сохранённой пары…',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _submit,
                    child: const Text('Конвертировать'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
