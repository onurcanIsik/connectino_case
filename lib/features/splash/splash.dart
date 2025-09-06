import 'package:auto_route/auto_route.dart';
import 'package:connectino/core/constant/app_constant.dart';
import 'package:connectino/core/utils/router/app_router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus(context);
  }

  Future<void> _checkUserStatus(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (context.mounted) {
        context.router.replaceAll([const HomeRoute()]);
      }
    } else {
      if (context.mounted) {
        context.router.replaceAll([const AuthRoute()]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                AppConstant.appName,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              CircularProgressIndicator(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
