// ignore_for_file: unused_element

import 'package:connectino/core/network/network_providers.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectino/core/utils/router/app_router.gr.dart';

Future<bool> hasInternet() async {
  try {
    final result = await InternetConnection().hasInternetAccess;
    return result;
  } catch (_) {
    return false;
  }
}

class ConnectivityGate extends ConsumerStatefulWidget {
  const ConnectivityGate({
    super.key,
    required this.router,
    required this.child,
  });
  final RootStackRouter router;
  final Widget child;

  @override
  ConsumerState<ConnectivityGate> createState() => _ConnectivityGateState();
}

class _ConnectivityGateState extends ConsumerState<ConnectivityGate> {
  String? _lastRouteName() => widget.router.topRoute.name;

  bool get _isOnOffline => widget.router.topRoute.name == OfflineRoute.name;

  bool _navigating = false;

  Future<void> _toOffline() async {
    if (_navigating || _isOnOffline) return;
    _navigating = true;
    await widget.router.replaceAll([const OfflineRoute()]);
    _navigating = false;
  }

  Future<void> _backOnline() async {
    if (_navigating) return;
    // Offline'dan çıkıp akışı tekrar başlat: LaunchGate → (Splash/Auth)
    if (_isOnOffline) {
      _navigating = true;
      await widget.router.replaceAll([const LaunchGateRoute()]);
      _navigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<NetworkStatus>>(netStatusProvider, (prev, next) {
      next.whenData((s) async {
        if (s == NetworkStatus.offline) {
          await _toOffline();
        } else {
          await _backOnline();
        }
      });
    });

    return widget.child; // sadece dinleyici; UI'ya dokunmuyor
  }
}
