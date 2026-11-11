import 'package:flutter/material.dart';
import 'package:focusbank/theme/app_colors.dart';

/// The yellow rounded button used across the app.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  /// The text shown inside the button.
  final String label;

  /// The function to run when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.yellow,
        foregroundColor: Colors.black, // color of the text
        shape: const StadiumBorder(), // fully rounded ends (pill shape)
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),//sets padding left and right (32) and top and bottom (14) separately.
      ),
      child: Text(label),
    );
  }
}