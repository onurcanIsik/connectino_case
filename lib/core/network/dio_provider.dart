// dio_provider.dart
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart';

// Dio'nun Provider tanımı, herhangi bir notifier kullanmıyor
final dioProvider = Provider<Dio>((ref) {
  // Provider'ın değerini oluşturma mantığı
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE']!,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final token = await user
                .getIdToken(false)
                .timeout(const Duration(seconds: 3));
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
        } catch (e, st) {
          debugPrint('[DIO] onRequest token fetch error: $e\n$st');
        } finally {
          handler.next(options);
        }
      },
      onError: (DioException e, handler) {
        debugPrint('[DIO] onError: ${e.type} ${e.message}');
        handler.next(e);
      },
    ),
  );

  return dio;
});
