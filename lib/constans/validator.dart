class AppValidators {
  static String? displayNameValidator(String? displayName) {
    if(displayName  == null || displayName.isEmpty){
      return "Display name cannot be empty.";
    }
    if(displayName.length < 3 || displayName.length > 20){
      return "Display name must be between 3 - 30 letters.";
    }
    return null;
  }

  static String? emailValidator(String? email){
    if(email!.isEmpty) {
      return "Please enter a email address.";
    }
    if(!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      return "Please enter a valid email address.";
    }
    return null;
  }

  static String? passwordValidator(String? password ){
    if(password!.isEmpty) {
      return "Please enter your password.";
    }
    if(password.length < 6){
      return "Password must be at least 6 characters.";
    }
    return null;
  }

  static String? passwordMatchValidator(String? password, String? passwordRepeat ){
    if(password != passwordRepeat) {
      return "Passwords do not match.";
    }
    return null;
  }
}