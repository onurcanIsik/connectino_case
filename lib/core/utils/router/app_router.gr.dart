// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:connectino/core/app/launch_gate.dart' as _i3;
import 'package:connectino/features/auth/view/auth_page.dart' as _i1;
import 'package:connectino/features/home/view/home_page.dart' as _i2;
import 'package:connectino/features/offline/view/offline_page.dart' as _i4;
import 'package:connectino/features/splash/splash.dart' as _i5;

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i6.PageRouteInfo<void> {
  const AuthRoute({List<_i6.PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.LaunchGatePage]
class LaunchGateRoute extends _i6.PageRouteInfo<void> {
  const LaunchGateRoute({List<_i6.PageRouteInfo>? children})
    : super(LaunchGateRoute.name, initialChildren: children);

  static const String name = 'LaunchGateRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.LaunchGatePage();
    },
  );
}

/// generated route for
/// [_i4.OfflinePage]
class OfflineRoute extends _i6.PageRouteInfo<void> {
  const OfflineRoute({List<_i6.PageRouteInfo>? children})
    : super(OfflineRoute.name, initialChildren: children);

  static const String name = 'OfflineRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.OfflinePage();
    },
  );
}

/// generated route for
/// [_i5.SplashPage]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute({List<_i6.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.SplashPage();
    },
  );
}
