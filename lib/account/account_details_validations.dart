
extension Validations on String {
  String? get basicValidation {
    if (this.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

  String? get passwordValidation {
    return null;
  }
}