import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:realtime_firebase_chatapp/core/app/app_router.dart';
import 'package:realtime_firebase_chatapp/screens/login/cubit/login_cubit.dart';
import 'package:realtime_firebase_chatapp/screens/sign_up/view/sign_up_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            _EmailInput(),
            const SizedBox(height: 8),
            _PasswordInput(),
            const SizedBox(height: 8),
            _LoginButton(),
            const SizedBox(height: 4),
            _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.email.displayError,
    );

    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'email',
        helperText: '',
        errorText: displayError != null ? 'invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.password.displayError,
    );

    final isObscured = context.select(
      (LoginCubit cubit) => cubit.state.isObscured,
    );

    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: context.read<LoginCubit>().passwordChanged,
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: 'password',
        helperText: '',
        errorText: displayError != null ? 'invalid password' : null,
        suffixIcon: IconButton(
          onPressed: context.read<LoginCubit>().passwordVisibilityChanged,
          icon: Icon(
            !isObscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (LoginCubit cubit) => cubit.state.status.isInProgress,
    );

    if (isInProgress) return const CircularProgressIndicator();

    final isValid = context.select((LoginCubit cubit) => cubit.state.isValid);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('loginForm_continue_raisedButton'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: const Color(0xFFFFD600),
        ),
        onPressed: isValid ? () {} : null,
        child: const Text('LOGIN'),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => context.read<AppRouter>().push(const SignUpScreen()),
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
