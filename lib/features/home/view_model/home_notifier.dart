import 'package:connectino/core/models/notes_model.dart';
import 'package:connectino/features/home/repo/Home.service.dart';
import 'package:connectino/features/home/view_model/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeService _homeService = HomeService();

  HomeNotifier() : super(HomeState());

  Future<void> fetchNotes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _homeService.fetchNotes();
    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (notes) {
        state = state.copyWith(isLoading: false, notes: notes);
      },
    );
  }

  Future<void> addNote(NotesModel note, String docId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _homeService.saveNotes(note, docId);
    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (_) async {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> updateNote(NotesModel note, String uid) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _homeService.updateNotes(note);
    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (_) async {
        final updatedNotes = await _homeService.fetchNotes();
        updatedNotes.fold(
          (error) {
            state = state.copyWith(isLoading: false, errorMessage: error);
          },
          (notes) {
            state = state.copyWith(isLoading: false, notes: notes);
          },
        );
      },
    );
  }

  Future<void> deleteNote(String uid) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _homeService.deleteNotes(uid);
    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error);
      },
      (_) async {
        final updatedNotes = await _homeService.fetchNotes();
        updatedNotes.fold(
          (error) {
            state = state.copyWith(isLoading: false, errorMessage: error);
          },
          (notes) {
            state = state.copyWith(isLoading: false, notes: notes);
          },
        );
      },
    );
  }
}
