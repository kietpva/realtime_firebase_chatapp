part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isObscured = true,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final bool isObscured;

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isObscured,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isObscured: isObscured ?? this.isObscured,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid => Formz.validate([email, password]);

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        errorMessage,
        isObscured,
      ];
}
