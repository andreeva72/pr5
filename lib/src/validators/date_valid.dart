DateTime? parseDateTime(String input) {
  try {
    return DateTime.parse(input);
  } catch (_) {
    return null;
  }
}

bool isValidDateTime(String input) {
  return parseDateTime(input) != null;
}
