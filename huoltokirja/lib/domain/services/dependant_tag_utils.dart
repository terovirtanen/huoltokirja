import '../models/dependant.dart';

List<String> extractTagWords(String? rawTag) {
  if (rawTag == null || rawTag.trim().isEmpty) {
    return const [];
  }

  final seen = <String>{};
  final tags = <String>[];

  for (final part in rawTag.split(RegExp(r'[\s,]+'))) {
    final normalized = part.trim().toLowerCase();
    if (normalized.isEmpty || !seen.add(normalized)) {
      continue;
    }
    tags.add(normalized);
  }

  return tags;
}

List<String> collectAvailableTags(Iterable<Dependant> dependants) {
  final seen = <String>{};
  final tags = <String>[];

  for (final dependant in dependants) {
    for (final tag in extractTagWords(dependant.tag)) {
      if (seen.add(tag)) {
        tags.add(tag);
      }
    }
  }

  return tags;
}

bool matchesSelectedTags(Dependant dependant, Set<String> selectedTags) {
  if (selectedTags.isEmpty) {
    return true;
  }

  final normalizedSelection = selectedTags
      .map((tag) => tag.trim().toLowerCase())
      .where((tag) => tag.isNotEmpty)
      .toSet();
  final tagWords = extractTagWords(dependant.tag).toSet();
  if (tagWords.isEmpty) {
    return false;
  }

  return normalizedSelection.any(tagWords.contains);
}
