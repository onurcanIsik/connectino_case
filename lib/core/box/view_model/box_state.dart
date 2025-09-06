class BoxState {
  final bool isOnline;
  final bool isLoading;
  final String? errorMessage;
  final List<Map<String, dynamic>> notes;
  BoxState({
    this.isOnline = false,
    this.isLoading = false,
    this.errorMessage,
    this.notes = const [],
  });

  BoxState copyWith({
    bool? isOnline,
    bool? isLoading,
    String? errorMessage,
    List<Map<String, dynamic>>? notes,
  }) {
    return BoxState(
      isOnline: isOnline ?? this.isOnline,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      notes: notes ?? this.notes,
    );
  }
}
