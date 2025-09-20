import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../BLOC/Login/Login_bloc.dart';
 import '../../BLOC/Login/Login_event.dart' show EmailChanged, PasswordChanged, LoginSubmitted;
import '../../BLOC/Login/Login_state.dart' show LoginState, LoginStatus;
import '../../Core/app_colors.dart' show AppColors;
import 'HomeScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final violet = AppColors.violet;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.status == LoginStatus.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login successful!')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state.status == LoginStatus.loading;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo / header
                      Icon(Icons.lock_outline, size: 64, color: violet),
                      const SizedBox(height: 16),
                      Text('Welcome Back',
                          style: Theme.of(context).textTheme.headlineSmall),

                      const SizedBox(height: 24),

                      // Email
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) =>
                            context.read<LoginBloc>().add(EmailChanged(v)),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText: state.email.isEmpty
                              ? null
                              : (state.isValid ? null : 'Enter a valid email'),
                          border: const OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Password
                      _PasswordField(
                        onChanged: (v) =>
                            context.read<LoginBloc>().add(PasswordChanged(v)),
                        showError: state.password.isNotEmpty &&
                            state.password.length < 6,
                      ),

                      const SizedBox(height: 16),

                      if (state.error != null &&
                          state.status == LoginStatus.failure)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            state.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),

                      // Login button (violet)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: violet,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () => context
                              .read<LoginBloc>()
                              .add(const LoginSubmitted()),
                          child: isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                              : const Text('Login'),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Hint for mock credentials
                      Text(
                        'Hint: password is "123456" in demo',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final bool showError;

  const _PasswordField({
    required this.onChanged,
    required this.showError,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscure,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
        ),
        errorText: widget.showError ? 'At least 6 characters' : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
