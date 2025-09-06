import 'package:auto_route/auto_route.dart';
import 'package:connectino/core/constant/app_constant.dart';
import 'package:connectino/core/extensions/extensions.dart';
import 'package:connectino/widgets/authWidget/login_form.dart';
import 'package:connectino/widgets/authWidget/register_form.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth = context.dynamicWidth(0.9);
    final cardHeight = context.dynamicHeight(0.44);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 520,
                maxHeight: context.dynamicHeight(0.9),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      AppConstant.appName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: cardWidth,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,

                        indicator: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        physics: BouncingScrollPhysics(),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black54,
                        tabs: [
                          Tab(text: 'Giriş Yap'),
                          Tab(text: 'Üye Ol'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: cardWidth,
                      height: cardHeight,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const TabBarView(
                        physics: BouncingScrollPhysics(),
                        children: [LoginForm(), RegisterForm()],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
