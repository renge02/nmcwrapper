bool validPasswordOld(String passwordInput) {
  return (passwordInput.isNotEmpty && passwordInput.length >= 8);
}

bool validEmail(String emailInput) {
  final regex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return regex.hasMatch(emailInput);
}

bool validPassword(String password) {
  return RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-\\/\[\];+]).{8,20}$',
  ).hasMatch(password);
}