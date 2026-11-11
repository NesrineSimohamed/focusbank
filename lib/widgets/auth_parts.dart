import 'package:flutter/material.dart';
import 'package:focusbank/theme/app_colors.dart';

/// Logo + title + subtitle at the top of the auth screens.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBack; // show the yellow "<" arrow?

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBack = false, // default: no arrow (Login, Sign Up step 1)
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 80,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.access_time,
            color: AppColors.yellow,
            size: 64,
          ),
        ),
        const SizedBox(height: 16),
        // Stack: the title stays centered, the arrow floats on the left.
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.yellow,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showBack) // "if" inside a list: add the widget only if true
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  // pop = remove this screen, go back to the previous one.
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.yellow,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

/// Bottom bar: a divider, then "question + yellow link".
class AuthFooter extends StatelessWidget {
  final String question;
  final String linkText;
  final VoidCallback onTap; // a function to run when the link is tapped

  const AuthFooter({
    super.key,
    required this.question,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: AppColors.fieldBorder, thickness: 2),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question, style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 8),
            // GestureDetector makes any widget tappable.
            GestureDetector(
              onTap: onTap,
              child: Text(
                linkText,
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}