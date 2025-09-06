import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectino/core/models/user_model.dart';
import 'package:connectino/features/auth/repo/IAuth.service.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService implements IAuthService {
  final fb = FirebaseFirestore.instance;
  final fba = FirebaseAuth.instance;

  @override
  Future<Either<String, Unit>> registerUser(UserModel userModel) async {
    try {
      final userCredential = await fba.createUserWithEmailAndPassword(
        email: userModel.userMail!,
        password: userModel.userPassword!,
      );

      userModel.userId = userCredential.user!.uid;

      await fb
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set(userModel.toJson());

      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(e.message!);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> loginUser(UserModel userModel) async {
    try {
      final _ = await fba.signInWithEmailAndPassword(
        email: userModel.userMail!,
        password: userModel.userPassword!,
      );

      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(e.message!);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> logoutUser() async {
    try {
      await fba.signOut();
      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(e.message!);
    } catch (e) {
      return left(e.toString());
    }
  }
}
