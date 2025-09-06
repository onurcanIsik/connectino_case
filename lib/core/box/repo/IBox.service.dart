import 'package:dartz/dartz.dart';

abstract class IBoxService {
  Future<Either<String, Unit>> addNote(
    Map<String, dynamic> note, {
    required bool isOnline,
  });
  Future<Either<String, List<Map<String, dynamic>>>> getNotes();
  Future<Either<String, Unit>> updateNote(Map<String, dynamic> note);
  Future<Either<String, Unit>> deleteNote(String noteId);
}
