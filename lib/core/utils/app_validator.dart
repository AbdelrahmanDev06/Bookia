class AppValidator {
  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'This field is required' : null;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
    return ok ? null : 'Enter a valid email';
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? Function(String?) confirm(String Function() original) =>
      (value) {
        if (value == null || value.isEmpty) return 'Please confirm the password';
        return value == original() ? null : 'Passwords do not match';
      };

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone is required';
    final ok = RegExp(r'^\+?[0-9]{8,15}$').hasMatch(value.trim());
    return ok ? null : 'Enter a valid phone number';
  }
}
