import 'package:flutter/material.dart';
import 'package:focusbank/screens/login_screen.dart';
import 'package:focusbank/screens/signup_profile_screen.dart';
import 'package:focusbank/theme/app_colors.dart';
import 'package:focusbank/utils/validators.dart';
import 'package:focusbank/widgets/auth_parts.dart';
import 'package:focusbank/widgets/auth_text_field.dart';
import 'package:focusbank/widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // The handle used to validate the whole Form.
  final _formKey = GlobalKey<FormState>();
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
    // validate() runs every validator; false = at least one error.
    if (!_formKey.currentState!.validate()) return;

    // All good: go to step 2 and hand over the data.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpProfileScreen(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      ),
    );
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
                // Form wraps the fields so they can be validated together.
                child: Form(
                  key: _formKey,
                  // After the first interaction, errors update live.
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: 'Password',
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: true,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: 'Confirm Password',
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        controller: _confirmController,
                        isPassword: true,
                        // Inline validator: compare with the password field.
                        validator: (value) =>
                            value != _passwordController.text
                                ? 'Passwords do not match'
                                : null,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child:
                            PrimaryButton(label: 'Next', onPressed: _onNext),
                      ),
                    ],
                  ),
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