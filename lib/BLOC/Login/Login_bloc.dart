import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_pullrequest/BLOC/Login/Login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Data/Services/LoginService.dart' show AuthService;
import 'Login_event.dart' show LoginEvent, EmailChanged, PasswordChanged, LoginSubmitted;



class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService auth;

  LoginBloc(this.auth) : super(const LoginState()) {
    on<EmailChanged>((e, emit) => emit(state.copyWith(email: e.email, error: null)));
    on<PasswordChanged>((e, emit) => emit(state.copyWith(password: e.password, error: null)));
    on<LoginSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(error: "Please enter a valid email and password"));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading, error: null));

    try {
      await auth.login(email: state.email, password: state.password);

      // ✅ Save login status in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isUserLoggedIn", true);

      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e.toString()));
    }
  }


}
