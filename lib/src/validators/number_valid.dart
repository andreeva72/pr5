bool isGreaterThanZero(num value) {
  return value > 0;
}

bool isGreaterOrEqualZero(num value) {
  return value >= 0;
}

double? parseDouble(String input) {
  try {
    return double.parse(input.replaceAll(',', '.'));
  } catch (_) {
    return null;
  }
}

int? parsePositiveInt(String input) {
  try {
    final value = int.parse(input);
    return value > 0 ? value : null;
  } catch (_) {
    return null;
  }
}
