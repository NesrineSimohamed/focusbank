import 'package:flutter/material.dart';
import 'package:focusbank/screens/signup_screen.dart';
import 'package:focusbank/theme/app_colors.dart';
import 'package:focusbank/widgets/auth_parts.dart';
import 'package:focusbank/widgets/auth_text_field.dart';
import 'package:focusbank/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers let us read what the user typed.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Called automatically when the screen is closed: free the controllers.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    // TODO: send email + password to the backend (later step).
    debugPrint('Login: ${_emailController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Expanded = take all the space left above the footer.
            Expanded(
              // Scrollable so the keyboard never causes an overflow.
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const AuthHeader(
                      title: 'Log In',
                      subtitle: 'Enter your email and password to securely '
                          'access your account and manage your services.',
                    ),
                    const SizedBox(height: 40),
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
                    const SizedBox(height: 32),
                    // SizedBox with infinite width = full-width button.
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(label: 'Log In', onPressed: _onLogin),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AuthFooter(
                question: "Don't have an account ?",
                linkText: 'Sign Up here',
                // Replace this screen with Sign Up (stack doesn't grow).
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}