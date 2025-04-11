import 'dart:async';

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
    on<AuthCheckAuthentication>(_onUserSubscriptionRequested);
    on<AuthLogoutPressed>(_onLogoutPressed);
  }

  final AuthRepository _authRepository;
  StreamSubscription<User?>? authStateSubscription;

  Future<void> _onUserSubscriptionRequested(
    AuthCheckAuthentication event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach(
      _authRepository.authStateChanges,
      onData: (user) async {
        if (user != null) {
          final userData = await _authRepository.getUserData(user.uid);

          emit(AuthState(user: userData));
        } else {
          emit(const AuthState(user: UserModel.empty));
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(AuthLogoutPressed event, Emitter<AuthState> emit) {
    _authRepository.singOut();
  }
}
