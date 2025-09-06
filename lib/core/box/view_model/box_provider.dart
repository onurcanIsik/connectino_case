import 'package:connectino/core/box/view_model/box_notifier.dart';
import 'package:connectino/core/box/view_model/box_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final boxProvider = StateNotifierProvider<BoxNotifier, BoxState>(
  (ref) => BoxNotifier(),
);
