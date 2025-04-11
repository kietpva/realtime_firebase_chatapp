import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:realtime_firebase_chatapp/core/utils/validation.dart';
import 'package:realtime_firebase_chatapp/data/repositories/auth_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpState());

  final AuthRepository _authRepository;
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

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authRepository.signUp(
        fullName: state.fullName.value,
        username: state.username.value,
        email: state.email.value,
        phoneNumber: state.phoneNumber.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'An unknown error occurred',
        ),
      );
    }
  }
}
