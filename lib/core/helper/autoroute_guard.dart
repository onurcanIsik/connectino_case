// autoroute_guard.dart
// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:connectino/core/utils/router/app_router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver r, StackRouter router) async {
    final name = r.route.name;
    if (name == AuthRoute.name) {
      r.next(true);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      r.redirect(const AuthRoute());
      return;
    }

    final online = await InternetConnection().hasInternetAccess.catchError(
      (_) => false,
    );
    if (!online) {
      r.next(true);
      return;
    }

    try {
      await user.getIdToken();
      r.next(true);
    } catch (_) {
      await FirebaseAuth.instance.signOut();
      r.redirect(const AuthRoute());
    }
  }
}
