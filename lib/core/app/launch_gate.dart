// lib/features/launch_gate/view/launch_gate_page.dart

// ignore_for_file: unrelated_type_equality_checks

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:connectino/core/utils/router/app_router.gr.dart';

@RoutePage()
class LaunchGatePage extends StatefulWidget {
  const LaunchGatePage({super.key});

  @override
  State<LaunchGatePage> createState() => _LaunchGatePageState();
}

class _LaunchGatePageState extends State<LaunchGatePage> {
  bool _decided = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    if (_decided) return;
    _decided = true;

    try {
      final conn = await Connectivity().checkConnectivity();
      if (!mounted) return;

      if (conn == ConnectivityResult.none) {
        context.router.replaceAll([const OfflineRoute()]);
        return;
      }

      final online = await InternetConnection().hasInternetAccess.timeout(
        const Duration(seconds: 20),
        onTimeout: () => false,
      );

      if (!mounted) return;

      if (online) {
        context.router.replaceAll([const SplashRoute()]);
      } else {
        context.router.replaceAll([const OfflineRoute()]);
      }
    } catch (_) {
      if (!mounted) return;
      context.router.replaceAll([const OfflineRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
