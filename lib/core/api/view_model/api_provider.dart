// lib/features/api/view_model/api_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:connectino/core/network/dio_provider.dart';
import 'package:connectino/core/api/repo/Api.service.dart';
import 'package:connectino/core/api/view_model/api_notifier.dart';
import 'package:connectino/core/api/view_model/api_state.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

// The provider is a regular StateNotifierProvider
final apiProvider = StateNotifierProvider<ApiNotifier, ApiState>((ref) {
  final svc = ref.watch(apiServiceProvider);
  return ApiNotifier(svc);
});
