class Validators {
  static String? phoneNumber(String? text) {
    if (text != null) {
      if (text.isEmpty) {
        return "Please enter your phone number!";
      } else if (text.length < 10) {
        return "Please enter valid phone number!";
      }
    }
    return null;
  }

  static String? email(String? text) {
    final RegExp _regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (text != null) {
      final bool _validEmail = _regex.hasMatch(text);
      if (text.isEmpty) {
        return "Please enter your email address!";
      } else if (!_validEmail) {
        return "Please enter valid email address!";
      }
    }
    return null;
  }

  static String? commonString(String? text) {
    if (text != null) {
      if (text.isEmpty) {
        return "This field must not be empty!";
      }
    }
    return null;
  }
}
