
extension Validations on String {
  String? get basicValidation {
    if (this.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

  String? get passwordValidation {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(this) ? null : 'Check the password criteria';
  }
}