import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_firebase_chatapp/data/models/user_model.dart';
import 'package:realtime_firebase_chatapp/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthState()) {
    on<AuthCheckAuthentication>(
      _authCheckAuthentication,
      transformer: restartable(),
    );

    on<AuthLogoutPressed>(_onLogoutPressed);
  }

  final AuthRepository _authRepository;
  StreamSubscription<User?>? authStateSubscription;

  Future<void> _authCheckAuthentication(
    AuthCheckAuthentication event,
    Emitter<AuthState> emit,
  ) async {
    return emit.onEach(
      _authRepository.authStateChanges,
      onData: (user) async {
        if (user != null) {
          if (state.user == UserModel.empty) {
            final userData = await _authRepository.getUserData(user.uid);
            emit(AuthState(user: userData));
          }
        } else {
          emit(const AuthState(user: UserModel.empty));
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(AuthLogoutPressed event, Emitter<AuthState> emit) {
    emit(const AuthState(user: UserModel.empty));
    _authRepository.signOut();
  }
}
