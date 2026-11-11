import 'package:flutter/material.dart';
import 'package:focusbank/screens/login_screen.dart';
import 'package:focusbank/theme/app_colors.dart';
import 'package:focusbank/widgets/auth_parts.dart';
import 'package:focusbank/widgets/auth_text_field.dart';
import 'package:focusbank/widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onNext() {
    // Quick check: the two passwords must match.
    if (_passwordController.text != _confirmController.text) {
      // SnackBar = small message at the bottom of the screen.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    // TODO: go to the next sign-up step / call the backend.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const AuthHeader(
                      title: 'Sign Up',
                      subtitle: 'Create a new account to get started and '
                          'enjoy seamless access to our features.',
                    ),
                    const SizedBox(height: 32),
                    AuthTextField(
                      label: 'Email Address',
                      hint: 'Exemple@gmail.com',
                      icon: Icons.mail_outline,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: 'Confirm Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      controller: _confirmController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(label: 'Next', onPressed: _onNext),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AuthFooter(
                question: 'Already have an account?',
                linkText: 'Log In here',
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}