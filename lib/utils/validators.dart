/// All the form checks in one place, so every screen can reuse them.
/// Each function returns null if OK, or an error message if not.
class Validators {
  // The pattern: letters/digits before "@", then a domain, a dot, an ending.
  static final RegExp _emailRegex =
      RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)*\.[a-zA-Z]{2,}$');

  static String? email(String? value) {
    final text = value?.trim() ?? ''; // ?? '' = use '' if value is null
    if (text.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(text)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password is required';
    if (text.length < 6) return 'At least 6 characters';
    return null;
  }

  // Generic "must not be empty" check, with the field name in the message.
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? income(String? value) {
    final text = (value ?? '').replaceAll(',', '').trim(); // "3,000" -> "3000"
    if (text.isEmpty) return 'Dream income is required';
    final number = double.tryParse(text); // null if it's not a number
    if (number == null || number <= 0) return 'Enter a valid amount';
    return null;
  }
}