import 'package:connectino/core/models/user_model.dart';
import 'package:connectino/features/auth/view_model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final authNoti = ref.read(authProvider.notifier);
    final authState = ref.watch(authProvider);
    final mailController = useTextEditingController();
    final passController = useTextEditingController();

    final obscure = useState(true);

    return SingleChildScrollView(
      child: AutofillGroup(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: mailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'E-posta gerekli';
                  final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v);
                  return ok ? null : 'Geçerli bir e-posta girin';
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => obscure.value = !obscure.value,
                  ),
                ),
                obscureText: obscure.value,
                autofillHints: const [AutofillHints.password],
                validator: (v) =>
                    (v == null || v.length < 6) ? 'En az 6 karakter' : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: authState.isLoading == false
                    ? FilledButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            authNoti.loginUser(
                              UserModel(
                                userMail: mailController.text.trim(),
                                userPassword: passController.text.trim(),
                              ),
                              context,
                            );
                          }
                        },
                        child: Text('Giriş Yap'),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
