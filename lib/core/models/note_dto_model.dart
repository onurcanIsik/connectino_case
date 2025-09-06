// lib/features/notes/data/note_dto.dart
class NoteDto {
  final String id;
  final String title;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NoteDto({
    required this.id,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory NoteDto.fromJson(Map<String, dynamic> j) => NoteDto(
    id: j['id'] as String,
    title: j['title'] as String,
    content: j['content'] as String,
    createdAt: j['created_at'] != null
        ? DateTime.parse(j['created_at'] as String)
        : null,
    updatedAt: j['updated_at'] != null
        ? DateTime.parse(j['updated_at'] as String)
        : null,
  );
}
