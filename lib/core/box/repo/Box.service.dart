import 'package:connectino/core/box/repo/IBox.service.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

class BoxService implements IBoxService {
  final onlineBox = Hive.box('onlineNotes');
  final offlineBox = Hive.box('offlineNotes');

  @override
  Future<Either<String, Unit>> addNote(
    Map<String, dynamic> note, {
    required bool isOnline,
  }) async {
    try {
      if (isOnline) {
        onlineBox.put(note['id'], note);
      } else {
        offlineBox.put(note['id'], note);
      }
      return right(unit);
    } catch (ex) {
      return left(ex.toString());
    }
  }

  @override
  Future<Either<String, Unit>> deleteNote(String noteId) async {
    try {
      onlineBox.delete(noteId);
      return right(unit);
    } catch (ex) {
      return left(ex.toString());
    }
  }

  @override
  Future<Either<String, List<Map<String, dynamic>>>> getNotes() async {
    try {
      final onlineNotes = onlineBox.values
          .cast<Map<String, dynamic>>()
          .toList();
      final offlineNotes = offlineBox.values
          .cast<Map<String, dynamic>>()
          .toList();
      return right([...onlineNotes, ...offlineNotes]);
    } catch (ex) {
      return left(ex.toString());
    }
  }

  @override
  Future<Either<String, Unit>> updateNote(Map<String, dynamic> note) async {
    try {
      onlineBox.put(note['id'], note);
      return right(unit);
    } catch (ex) {
      return left(ex.toString());
    }
  }
}
