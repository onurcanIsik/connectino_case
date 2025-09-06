import 'package:connectino/features/auth/view_model/auth_notifier.dart';
import 'package:connectino/features/auth/view_model/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
