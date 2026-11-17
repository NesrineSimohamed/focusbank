import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focusbank/screens/login_screen.dart';
import 'package:focusbank/services/auth_service.dart';
import 'package:focusbank/theme/app_colors.dart';
import 'package:focusbank/widgets/primary_button.dart';

/// Temporary screen: proves we are logged in. Will become the Dashboard.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // currentUser = the account that is logged in right now.
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // column only as tall as its content
          children: [
            Text(
              'Logged in as\n${user?.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Log out',
              onPressed: () async {
                await AuthService().logOut();
                // After an await, make sure the screen still exists.
                if (!context.mounted) return;
                // Open Login AND clear every previous screen from the stack.
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}