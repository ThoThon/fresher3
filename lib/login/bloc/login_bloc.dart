import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/login_request.dart';
import '../repositories/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthRepository _authRepository = AuthRepository();

  LoginBloc() : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(
        isLoading: true, errorMessage: '', isLoginSuccess: false));

    try {
      final request = LoginRequest(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      final success = await _authRepository.login(request);

      if (success) {
        emit(state.copyWith(isLoading: false, isLoginSuccess: true));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Đăng nhập thất bại, vui lòng thử lại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Có lỗi xảy ra, vui lòng thử lại",
      ));
    }
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
