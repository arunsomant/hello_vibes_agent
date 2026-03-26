class AppValidator {
  AppValidator._();

  static bool validateName(String name) {
    String pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regExp = RegExp(pattern);
    if (name.isEmpty) {
      return false;
    } else if (regExp.hasMatch(name)) {
      return false;
    }
    return true;
  }

  static bool validateAccountNumber(String accountNumber) {
    if (accountNumber.isEmpty) return false;

    // Pattern: Only digits, length between 9 and 18
    final regExp = RegExp(r'^\d{9,18}$');
    return regExp.hasMatch(accountNumber.trim());
  }

  static bool validateIFSC(String ifsc) {
    if (ifsc.isEmpty) return false;

    // Pattern: 4 letters, one zero, 6 alphanumeric characters
    final regExp = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    return regExp.hasMatch(ifsc.trim().toUpperCase());
  }

  static bool validateDateOfBirth(DateTime dob) {
    return dob.isBefore(
      DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
  }
}
