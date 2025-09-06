// lib/core/app/app.dart
import 'package:connectino/core/connection/connection_check.dart';
import 'package:flutter/material.dart';
import 'package:connectino/core/utils/router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key, required this.appRouter});
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    final config = appRouter.config();

    return ConnectivityGate(
      router: appRouter,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: config,
      ),
    );
  }
}
