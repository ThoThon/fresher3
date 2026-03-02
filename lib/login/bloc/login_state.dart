import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final String errorMessage;
  final bool isLoginSuccess;

  const LoginState({
    this.isLoading = false,
    this.errorMessage = '',
    this.isLoginSuccess = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isLoginSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isLoginSuccess];
}