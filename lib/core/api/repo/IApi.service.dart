import 'package:dartz/dartz.dart';

abstract class IApiService {
  Future<Either<String, String>> saveNotes(String title, String content);
  Future<Either<String, List>> fetchNotes();
  Future<Either<String, Unit>> updateNotes(
    String id,
    String title,
    String content,
  );
  Future<Either<String, Unit>> deleteNotes(String id);
}
