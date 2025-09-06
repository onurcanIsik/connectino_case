// lib/features/api/view_model/api_notifier.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:connectino/core/api/repo/Api.service.dart';
import 'api_state.dart';

class ApiNotifier extends StateNotifier<ApiState> {
  final ApiService _api;
  ApiNotifier(this._api) : super(ApiState());

  Future<void> fetchData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final res = await _api.fetchNotes();
    res.fold(
      (err) => state = state.copyWith(isLoading: false, errorMessage: err),
      (data) => state = state.copyWith(isLoading: false, notes: data),
    );
  }

  Future<String?> saveData(String title, String content) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final res = await _api.saveNotes(title, content);

    return res.fold(
      (err) {
        state = state.copyWith(isLoading: false, errorMessage: err);
        return null;
      },
      (id) {
        state = state.copyWith(isLoading: false);
        return id;
      },
    );
  }

  Future<void> updateData(String id, String title, String content) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final res = await _api.updateNotes(id, title, content);
    res.fold(
      (err) {
        state = state.copyWith(isLoading: false, errorMessage: err);
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> deleteData(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final res = await _api.deleteNotes(id);
    res.fold(
      (err) => state = state.copyWith(isLoading: false, errorMessage: err),
      (_) => state = state.copyWith(isLoading: false),
    );
  }
}
