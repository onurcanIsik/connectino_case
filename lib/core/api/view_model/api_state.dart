class ApiState {
  final bool isLoading;
  final String? errorMessage;
  final List? notes;

  ApiState({this.isLoading = false, this.errorMessage, this.notes});

  ApiState copyWith({bool? isLoading, String? errorMessage, List? notes}) {
    return ApiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      notes: notes ?? this.notes,
    );
  }
}
