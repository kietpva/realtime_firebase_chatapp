part of 'sign_up_cubit.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.fullName = const FullName.pure(),
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.isConfirmedPasswordDirty = false,
  });

  final FullName fullName;
  final Username username;
  final Email email;
  final PhoneNumber phoneNumber;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final bool isConfirmedPasswordDirty;

  SignUpState copyWith({
    FullName? fullName,
    Username? username,
    Email? email,
    PhoneNumber? phoneNumber,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzSubmissionStatus? status,
    String? errorMessage,
    bool? isConfirmedPasswordDirty,
  }) {
    return SignUpState(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isConfirmedPasswordDirty:
          isConfirmedPasswordDirty ?? this.isConfirmedPasswordDirty,
    );
  }

  bool get isValid => Formz.validate([
        fullName,
        username,
        phoneNumber,
        email,
        password,
        confirmedPassword,
        if (isConfirmedPasswordDirty) confirmedPassword,
      ]);

  @override
  List<Object?> get props => [
        fullName,
        username,
        phoneNumber,
        email,
        password,
        confirmedPassword,
        status,
        errorMessage,
        isConfirmedPasswordDirty,
      ];
}
