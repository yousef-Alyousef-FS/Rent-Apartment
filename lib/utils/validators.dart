class Validators {
  static String? isNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String? hasMinLength(String? value, int minLength) {
    if (value == null || value.length < minLength) {
      return 'Must be at least $minLength characters long';
    }
    return null;
  }

  // You can add more validators here, e.g., for email, phone numbers, etc.
}
