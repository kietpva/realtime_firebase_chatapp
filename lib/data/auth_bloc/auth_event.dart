part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthCheckAuthentication extends AuthEvent {
  const AuthCheckAuthentication();
}

final class AuthLogoutPressed extends AuthEvent {
  const AuthLogoutPressed();
}
