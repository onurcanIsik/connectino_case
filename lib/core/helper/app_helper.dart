// lib/core/helper/app_helper.dart
import 'package:connectino/core/connection/connection_check.dart';
import 'package:connectino/core/helper/autoroute_guard.dart';
import 'package:connectino/core/utils/router/app_router.dart';
import 'package:connectino/firebase_options.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppHelper {
  Future<AppDeps> init() async {
    final online = await hasInternet();
    debugPrint('aaaaaaaaa: $online');
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Hive.initFlutter();
    await Hive.openBox('onlineNotes');
    await Hive.openBox('offlineNotes');

    await dotenv.load(fileName: ".env");
    final baseUrl = dotenv.env['API_BASE'] ?? '';
    if (baseUrl.isEmpty) throw Exception('API_BASE missing');

    final dio = Dio(BaseOptions(baseUrl: baseUrl))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (opt, h) async {
            final t = await FirebaseAuth.instance.currentUser?.getIdToken();
            if (t != null) opt.headers['Authorization'] = 'Bearer $t';
            h.next(opt);
          },
        ),
      );

    final guard = AuthGuard();
    final router = AppRouter(guard);
    try {
      await FirebaseAuth.instance.setLanguageCode('tr');
    } catch (_) {}

    return AppDeps(dio: dio, router: router);
  }
}

class AppDeps {
  final Dio dio;
  final AppRouter router;
  AppDeps({required this.dio, required this.router});
}
