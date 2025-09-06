// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectino/core/app/app.dart';
import 'package:connectino/core/helper/app_helper.dart';
import 'package:connectino/core/network/dio_provider.dart';

void main() async {
  final deps = await AppHelper().init();
  runApp(
    ProviderScope(
      overrides: [dioProvider.overrideWithValue(deps.dio)],
      child: App(appRouter: deps.router),
    ),
  );
}
