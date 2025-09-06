// Hive’a yazmak için NotesModel -> Map
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectino/core/models/notes_model.dart';

Map<String, dynamic> noteToMap(NotesModel n, {bool pending = false}) {
  final created = n.createdAt ?? Timestamp.now();
  final updated = n.updatedAt ?? Timestamp.now();

  return {
    'id': n.id,
    'title': n.title,
    'content': n.content,
    // Hive içinde Timestamp yerine int (ms) saklayalım:
    'createdAt': created.millisecondsSinceEpoch,
    'updatedAt': updated.millisecondsSinceEpoch,
    'pending': pending, // Firestore’a daha gitmediyse true
  };
}

// Hive’dan okurken Map -> NotesModel
NotesModel mapToNote(Map<dynamic, dynamic> m) {
  final created = m['createdAt'] as int?;
  final updated = m['updatedAt'] as int?;

  return NotesModel(
    id: m['id'] as String?,
    title: m['title'] as String?,
    content: m['content'] as String?,
    createdAt: created != null
        ? Timestamp.fromMillisecondsSinceEpoch(created)
        : null,
    updatedAt: updated != null
        ? Timestamp.fromMillisecondsSinceEpoch(updated)
        : null,
  );
}
