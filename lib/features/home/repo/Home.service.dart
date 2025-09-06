import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectino/core/models/notes_model.dart';
import 'package:connectino/features/home/repo/IHome.service.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeService implements IHomeService {
  final fb = FirebaseFirestore.instance;
  final fba = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      fb.collection('Users').doc(uid).collection('notes');

  @override
  Future<Either<String, List<NotesModel>>> fetchNotes() async {
    try {
      // İstersen userId yerine her zaman currentUser kullan:
      final uid = fba.currentUser?.uid ?? '';
      if (uid.isEmpty) return const Left('Oturum yok');

      final snap = await _col(uid).orderBy('updatedAt', descending: true).get();

      final notes = snap.docs.map((d) {
        final data = d.data();
        return NotesModel(
          id: d.id,
          title: data['title'] as String?,
          content: data['content'] as String?,
          createdAt: data['createdAt'] as Timestamp?,
          updatedAt: data['updatedAt'] as Timestamp?,
        );
      }).toList();

      return Right(notes);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> saveNotes(
    NotesModel notesModel,
    String docId,
  ) async {
    try {
      final uid = fba.currentUser?.uid;
      if (uid == null) return const Left('Oturum yok');

      final now = Timestamp.now();
      await _col(uid).doc(docId).set({
        'id': notesModel.id ?? '',
        'title': notesModel.title ?? '',
        'content': notesModel.content ?? '',
        'createdAt': now,
        'updatedAt': now,
      });

      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> updateNotes(NotesModel notesModel) async {
    try {
      final uid = fba.currentUser?.uid;
      if (uid == null) return const Left('Oturum yok');
      if ((notesModel.id ?? '').isEmpty) return const Left('Geçersiz id');

      await _col(uid).doc(notesModel.id).update({
        if (notesModel.title != null) 'title': notesModel.title,
        if (notesModel.content != null) 'content': notesModel.content,
        'updatedAt': Timestamp.now(),
      });

      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> deleteNotes(String noteId) async {
    try {
      final uid = fba.currentUser?.uid;
      if (uid == null) return const Left('Oturum yok');
      if (noteId.isEmpty) return const Left('Geçersiz id');

      await _col(uid).doc(noteId).delete();
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
