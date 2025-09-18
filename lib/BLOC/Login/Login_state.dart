

import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final String? error;

  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.error,
  });

  bool get isValid => _isEmailValid(email) && password.length >= 6;

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [email, password, status, error];

  static bool _isEmailValid(String value) {
    final regex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    return regex.hasMatch(value);
  }
}
