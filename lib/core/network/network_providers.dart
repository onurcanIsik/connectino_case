// lib/core/connection/net_status.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum NetworkStatus { online, offline }

final netStatusProvider = StreamProvider<NetworkStatus>((ref) {
  final connectivity = Connectivity().onConnectivityChanged;

  final controller = StreamController<NetworkStatus>(sync: true);

  StreamSubscription? sub;
  Timer? debounce;

  Future<void> probeAndAdd() async {
    try {
      final ok = await InternetConnection().hasInternetAccess.timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
      controller.add(ok ? NetworkStatus.online : NetworkStatus.offline);
    } catch (_) {
      controller.add(NetworkStatus.offline);
    }
  }

  sub = connectivity.listen((_) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 250), probeAndAdd);
  });

  probeAndAdd();

  ref.onDispose(() {
    debounce?.cancel();
    sub?.cancel();
    controller.close();
  });

  return controller.stream.distinct();
});
