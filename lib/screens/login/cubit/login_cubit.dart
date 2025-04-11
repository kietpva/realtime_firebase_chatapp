import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:realtime_firebase_chatapp/core/utils/validation.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String email) =>
      emit(state.copyWith(email: Email.dirty(email)));

  void passwordChanged(String password) =>
      emit(state.copyWith(password: Password.dirty(password)));

  void passwordVisibilityChanged() {
    emit(state.copyWith(isObscured: !state.isObscured));
  }
}
