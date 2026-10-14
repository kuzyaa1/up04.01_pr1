// Форматирование чисел для экрана результата.
//
// Без округления деление вида 10/3 выводится как 3.3333333333333335,
// что запрещено заданием на оценку «5».

// Округляет [value] до [fractionDigits] знаков и убирает хвостовые нули.
// Целые значения показываются без дробной части: 8.0 -> «8».
String formatNumber(double value, [int fractionDigits = 6]) {
  if (value.isNaN || value.isInfinite) return value.toString();
  final fixed = value.toStringAsFixed(fractionDigits);
  var trimmed = fixed.replaceAll(RegExp(r'0+$'), '');
  if (trimmed.endsWith('.')) {
    trimmed = trimmed.substring(0, trimmed.length - 1);
  }
  // «-0» после округления показываем как «0».
  if (trimmed == '-0') return '0';
  return trimmed;
}
