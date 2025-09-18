class AuthService {
  // Fake call: replace with real http later
  Future<void> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    // simple fake rule: any non-empty email/pass and pass == "123456" succeeds
    if (email.isEmpty || password.isEmpty || password != "123456") {
      throw Exception("Invalid credentials");
    }
  }
}
