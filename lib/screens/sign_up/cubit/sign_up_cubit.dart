import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:realtime_firebase_chatapp/core/utils/validation.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  void usernameChanged(String username) =>
      emit(state.copyWith(username: Username.dirty(username)));

  void fullNameChanged(String fullName) =>
      emit(state.copyWith(fullName: FullName.dirty(fullName)));

  void phoneNumberChanged(String phoneNumber) =>
      emit(state.copyWith(phoneNumber: PhoneNumber.dirty(phoneNumber)));

  void emailChanged(String email) =>
      emit(state.copyWith(email: Email.dirty(email)));

  void passwordChanged(String password) => emit(
        state.copyWith(
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password,
            value: state.confirmedPassword.value,
          ),
        ),
      );

  void confirmedPasswordChanged(String confirmedPassword) {
    emit(
      state.copyWith(
        confirmedPassword: ConfirmedPassword.dirty(
          password: state.password.value,
          value: confirmedPassword,
        ),
        isConfirmedPasswordDirty: true,
      ),
    );
  }
}
