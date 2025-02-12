class Validators {
  /// Validates if a field is not empty
  static String? validateText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName cannot be empty";
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email cannot be empty";
    }
    // Email regex pattern
    const pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  /// Validates password (minimum 6 characters, at least 1 number)
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return "Password must contain at least one number";
    }
    return null;
  }
}