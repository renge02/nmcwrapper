bool validPassword(String passwordInput) {
  return (passwordInput.isNotEmpty && passwordInput.length >= 8);
}

bool validEmail(String emailInput) {
  final regex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return regex.hasMatch(emailInput);
}
