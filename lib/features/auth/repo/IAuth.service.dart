import 'package:connectino/core/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class IAuthService {
  Future<Either<String, Unit>> registerUser(UserModel userModel);
  Future<Either<String, Unit>> loginUser(UserModel userModel);
  Future<Either<String, Unit>> logoutUser();
}
