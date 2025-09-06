import 'package:connectino/core/models/notes_model.dart';
import 'package:dartz/dartz.dart';

abstract class IHomeService {
  Future<Either<String, Unit>> saveNotes(NotesModel notesModel, String docId);
  Future<Either<String, List<NotesModel>>> fetchNotes();
  Future<Either<String, Unit>> deleteNotes(String noteId);
  Future<Either<String, Unit>> updateNotes(NotesModel notesModel);
}
