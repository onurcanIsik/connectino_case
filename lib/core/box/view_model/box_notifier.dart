import 'package:connectino/core/box/repo/Box.service.dart';
import 'package:connectino/core/box/view_model/box_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoxNotifier extends StateNotifier<BoxState> {
  final BoxService _boxService = BoxService();
  BoxNotifier() : super(BoxState());

  Future<void> addNote(
    Map<String, dynamic> note, {
    required bool isOnline,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _boxService.addNote(note, isOnline: isOnline);

    if (!mounted) return;

    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> updateNote(
    Map<String, dynamic> note, {
    required bool isOnline,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _boxService.updateNote(note);

    if (!mounted) return;
    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> deleteNote(String noteId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _boxService.deleteNote(noteId);

    if (!mounted) return;

    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }
}
