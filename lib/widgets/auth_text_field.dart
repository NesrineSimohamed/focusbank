import 'package:flutter/material.dart';
import 'package:focusbank/theme/app_colors.dart';

/// A labeled text field used on Login and Sign Up.
/// Stateful because the password field must remember "hidden or visible".
class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword; // true = show the eye icon and hide the text
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

// The State class holds the data that can change.
class _AuthTextFieldState extends State<AuthTextField> {
  bool _hidden = true; // is the password currently hidden?

  // Helper to build the same border with a different color.
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label, // "widget." reaches the values above
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType, // email keyboard shows "@"
          // Hide the text only if it's a password AND _hidden is true.
          obscureText: widget.isPassword && _hidden,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(widget.icon, color: AppColors.textMuted),
            // Eye button only for password fields.
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _hidden ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textMuted,
                    ),
                    // setState tells Flutter to redraw with the new value.
                    onPressed: () => setState(() => _hidden = !_hidden),
                  )
                : null,
            enabledBorder: _border(AppColors.fieldBorder), // normal
            focusedBorder: _border(AppColors.yellow), // when tapped
          ),
        ),
      ],
    );
  }
}