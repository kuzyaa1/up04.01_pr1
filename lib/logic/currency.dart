const List<String> currencies = ['RUB', 'USD', 'EUR', 'CNY', 'KZT', 'BYN'];

/// Курс: сколько рублей стоит 1 единица валюты.
const Map<String, double> currencyRates = {
  'RUB': 1,
  'USD': 80,
  'EUR': 92,
  'CNY': 11,
  'KZT': 0.16,
  'BYN': 26.5,
};

// Результат конвертации: либо значение, либо описание ошибки.
sealed class ConvertResult {
  const ConvertResult();
}

class ConvertSuccess extends ConvertResult {
  final double value;
  const ConvertSuccess(this.value);
}

class ConvertFailure extends ConvertResult {
  final String message;
  const ConvertFailure(this.message);
}

ConvertResult convert({
  required String? rawFrom,
  required String? rawTo,
  required String? rawAmount,
}) {
  if (rawFrom == null || rawFrom.isEmpty) {
    return const ConvertFailure('Не указана исходная валюта');
  }
  if (rawTo == null || rawTo.isEmpty) {
    return const ConvertFailure('Не указана целевая валюта');
  }
  final rateFrom = currencyRates[rawFrom];
  final rateTo = currencyRates[rawTo];
  if (rateFrom == null || rateTo == null) {
    return const ConvertFailure('Неизвестная валюта');
  }

  final amount = double.tryParse((rawAmount ?? '').replaceAll(',', '.'));
  if (amount == null) {
    return const ConvertFailure('В адресе передана не числовая сумма');
  }
  if (amount < 0) {
    return const ConvertFailure('Сумма не может быть отрицательной');
  }

  return ConvertSuccess(amount * rateFrom / rateTo);
}
