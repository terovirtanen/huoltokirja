import 'package:intl/intl.dart';

enum NoteType { plain, service, inspection }

sealed class Note {
  const Note({
    this.id,
    this.schedulerId,
    this.schedulerTriggerKey,
    this.isUserModified = false,
    required this.dependantId,
    required this.title,
    required this.body,
    required this.noteDate,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? schedulerId;
  final String? schedulerTriggerKey;
  final bool isUserModified;
  final int dependantId;
  final String title;
  final String body;
  final DateTime noteDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isAutomaticallyCreated => schedulerId != null;
  NoteType get type;

  int? get estimatedCounter => null;
  String? get performerName => null;
  double? get price => null;
  bool get isApproved => false;

  String get listText;
}

class PlainNote extends Note {
  const PlainNote({
    super.id,
    super.schedulerId,
    super.schedulerTriggerKey,
    super.isUserModified,
    required super.dependantId,
    required super.title,
    required super.body,
    required super.noteDate,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  NoteType get type => NoteType.plain;

  @override
  String get listText {
    final dateText = _formatDate(noteDate);
    final trimmedBody = body.trim();
    return trimmedBody.isEmpty ? dateText : '$dateText • $trimmedBody';
  }
}

class ServiceNote extends Note {
  ServiceNote({
    super.id,
    super.schedulerId,
    super.schedulerTriggerKey,
    super.isUserModified,
    required super.dependantId,
    required super.title,
    required super.body,
    required DateTime serviceDate,
    this.estimatedCounter,
    this.performerName,
    this.price,
    required super.createdAt,
    required super.updatedAt,
  }) : super(noteDate: serviceDate);

  DateTime get serviceDate => noteDate;

  @override
  final int? estimatedCounter;

  @override
  final String? performerName;

  @override
  final double? price;

  @override
  NoteType get type => NoteType.service;

  @override
  String get listText {
    final parts = <String>[];
    if (estimatedCounter != null) parts.add('km-arvio: $estimatedCounter');
    if (performerName != null && performerName!.isNotEmpty) {
      parts.add('tekijä: $performerName');
    }
    if (price != null) parts.add('hinta: ${price!.toStringAsFixed(2)} €');
    final suffix = parts.isEmpty ? '' : ' • ${parts.join(' • ')}';
    return 'Huolto ${_formatDate(serviceDate)}$suffix';
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
    super.schedulerId,
    super.schedulerTriggerKey,
    super.isUserModified,
    required super.dependantId,
    required super.title,
    required super.body,
    required super.noteDate,
    this.estimatedCounter,
    this.performerName,
    this.price,
    this.isApproved = false,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  final int? estimatedCounter;

  @override
  final String? performerName;

  @override
  final double? price;

  @override
  final bool isApproved;

  @override
  NoteType get type => NoteType.inspection;

  @override
  String get listText {
    final dateText = _formatDate(noteDate);
    final parts = <String>[];
    if (estimatedCounter != null) parts.add('km-arvio: $estimatedCounter');
    if (performerName != null && performerName!.isNotEmpty) {
      parts.add('tekijä: $performerName');
    }
    if (price != null) parts.add('hinta: ${price!.toStringAsFixed(2)} €');
    if (isApproved) parts.add('hyväksytty');
    final suffix = parts.isEmpty ? '' : ' • ${parts.join(' • ')}';
    return 'Tarkastus $dateText$suffix';
  }
}

String _formatDate(DateTime date) => DateFormat.yMd().format(date);
