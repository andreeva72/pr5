bool isNotEmptyTrimmed(String value) {
  return value.trim().isNotEmpty;
}

bool isValidEmail(String email) {
  final trimmed = email.trim();
  return trimmed.contains('@') && trimmed.isNotEmpty;
}

bool isValidPhone(String phone) {
  return phone.trim().length >= 10;
}
