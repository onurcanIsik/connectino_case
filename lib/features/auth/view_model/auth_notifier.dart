import 'package:auto_route/auto_route.dart';
import 'package:connectino/core/models/user_model.dart';
import 'package:connectino/core/utils/router/app_router.gr.dart';
import 'package:connectino/features/auth/repo/Auth.service.dart';
import 'package:connectino/features/auth/view_model/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService();
  AuthNotifier() : super(AuthState());

  Future<void> registerUser(UserModel userModel) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _authService.registerUser(userModel);
    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> loginUser(UserModel userModel, BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _authService.loginUser(userModel);
    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (_) {
        state = state.copyWith(isLoading: false);
        if (context.mounted) {
          context.router.replaceAll([const HomeRoute()]);
        }
      },
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _authService.logoutUser();
    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (_) {
        state = state.copyWith(isLoading: false);
        if (context.mounted) {
          context.router.replaceAll([const AuthRoute()]);
        }
      },
    );
  }
}
