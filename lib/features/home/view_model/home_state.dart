import 'package:connectino/core/models/notes_model.dart';

class HomeState {
  bool isLoading;
  String? errorMessage;
  List<NotesModel> notes;

  HomeState({this.isLoading = false, this.errorMessage, this.notes = const []});

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<NotesModel>? notes,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      notes: notes ?? this.notes,
    );
  }
}
