import 'package:connectino/core/models/user_model.dart';
import 'package:connectino/features/auth/view_model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterForm extends HookConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final authNoti = ref.read(authProvider.notifier);
    final authState = ref.watch(authProvider);
    final mail = useTextEditingController();
    final pass = useTextEditingController();
    final pass2 = useTextEditingController();

    final obscure = useState(true);

    return SingleChildScrollView(
      child: AutofillGroup(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: mail,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.email_outlined),
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
                controller: pass,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => obscure.value = !obscure.value,
                  ),
                ),
                obscureText: obscure.value,
                validator: (v) =>
                    (v == null || v.length < 6) ? 'En az 6 karakter' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: pass2,
                decoration: const InputDecoration(
                  labelText: 'Şifre (Tekrar)',
                  prefixIcon: Icon(Icons.lock_reset),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) =>
                    (v != pass.text) ? 'Şifreler eşleşmiyor' : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: authState.isLoading == false
                    ? FilledButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            if (pass.text != pass2.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Şifreler eşleşmiyor'),
                                ),
                              );
                              return;
                            }
                            await authNoti.registerUser(
                              UserModel(
                                userMail: mail.text.trim(),
                                userPassword: pass.text.trim(),
                              ),
                            );
                          }
                        },
                        child: const Text('Hesap Oluştur'),
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
