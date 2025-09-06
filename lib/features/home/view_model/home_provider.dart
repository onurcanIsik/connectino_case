import 'package:connectino/features/home/view_model/home_notifier.dart';
import 'package:connectino/features/home/view_model/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);
