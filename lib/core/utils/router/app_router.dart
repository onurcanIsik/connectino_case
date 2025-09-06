import 'package:auto_route/auto_route.dart';
import 'package:connectino/core/helper/autoroute_guard.dart';
import 'package:connectino/core/utils/router/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard guard;

  AppRouter(this.guard);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LaunchGateRoute.page, initial: true),
    AutoRoute(page: SplashRoute.page),
    AutoRoute(page: AuthRoute.page),
    AutoRoute(page: HomeRoute.page, guards: [guard]),
    AutoRoute(page: OfflineRoute.page),
  ];
}
