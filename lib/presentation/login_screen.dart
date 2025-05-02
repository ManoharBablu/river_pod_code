import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/presentation/providers/login_provider.dart';
import 'package:sample_app/shared_utils/shared_utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

final _formkey = GlobalKey<FormState>();
final _userName = TextEditingController();
final _password = TextEditingController();

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final controller = ref.read(loginProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Login'),
      ),
      body: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                  controller: _userName,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter UserName' : null),
              TextFormField(
                  controller: _password,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter Password' : null),
              const SizedBox(
                height: 20,
              ),
              state.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          await controller.login(
                              _userName.text, _password.text);
                          if (ref.read(loginProvider).token.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Login Successfull')),
                            );
                          }
                        }
                        final token =
                            await SharedPreferencesUtil.getAuthToken();
                        if (token != null) {
                          log('Token: $token');
                          context.go('/products_screen', extra: token);
                        }
                      },
                      child: const Text('Login'))
            ],
          )),
    );
  }
}
