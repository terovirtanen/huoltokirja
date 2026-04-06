enum NoteType { service, inspection }

sealed class Note {
  const Note({
    this.id,
    required this.dependantId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int dependantId;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteType get type;

  String get listText;
}

class ServiceNote extends Note {
  const ServiceNote({
    super.id,
    required super.dependantId,
    required super.title,
    required super.body,
    required this.serviceDate,
    this.estimatedCounter,
    required super.createdAt,
    required super.updatedAt,
  });

  final DateTime serviceDate;
  final int? estimatedCounter;

  @override
  NoteType get type => NoteType.service;

  @override
  String get listText {
    final counter = estimatedCounter == null
        ? ''
        : ' | km arvaus: $estimatedCounter';
    return 'Huolto ${serviceDate.toIso8601String().split('T').first}$counter';
  }

  int estimateCounter(int currentCounter) {
    if (estimatedCounter == null) return currentCounter;
    if (estimatedCounter! < currentCounter) return currentCounter;
    return estimatedCounter!;
  }
}

class InspectionNote extends Note {
  const InspectionNote({
    super.id,
    required super.dependantId,
    required super.title,
    required super.body,
    this.inspectorName,
    required super.createdAt,
    required super.updatedAt,
  });

  final String? inspectorName;

  @override
  NoteType get type => NoteType.inspection;

  @override
  String get listText {
    final inspector = inspectorName == null || inspectorName!.isEmpty
        ? ''
        : ' ($inspectorName)';
    return 'Tarkastus$inspector';
  }
}
