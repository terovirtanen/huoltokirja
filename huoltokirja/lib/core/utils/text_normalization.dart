String capitalizeFirst(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return '';
  }

  final first = trimmed[0].toUpperCase();
  return '$first${trimmed.substring(1)}';
}