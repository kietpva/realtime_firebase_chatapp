import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:realtime_firebase_chatapp/screens/sign_up/cubit/sign_up_cubit.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FullNameInput(),
              const SizedBox(height: 8),
              _UserNameInput(),
              const SizedBox(height: 8),
              _PhoneNumberInput(),
              const SizedBox(height: 8),
              _EmailInput(),
              const SizedBox(height: 8),
              _PasswordInput(),
              const SizedBox(height: 8),
              _ConfirmPasswordInput(),
              const SizedBox(height: 8),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.fullName.displayError,
    );

    return TextField(
      key: const Key('signUpForm_fullNameInput_textField'),
      onChanged: (fullname) =>
          context.read<SignUpCubit>().fullNameChanged(fullname),
      decoration: InputDecoration(
        labelText: 'full name',
        helperText: '',
        errorText: displayError != null ? 'invalid full name' : null,
      ),
    );
  }
}

class _UserNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.username.displayError,
    );

    return TextField(
      key: const Key('signUpForm_userNameInput_textField'),
      onChanged: (userName) =>
          context.read<SignUpCubit>().usernameChanged(userName),
      decoration: InputDecoration(
        labelText: 'user name',
        helperText: '',
        errorText: displayError != null ? 'invalid user name' : null,
      ),
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.phoneNumber.displayError,
    );

    return TextField(
      key: const Key('signUpForm_phoneNumberInput_textField'),
      onChanged: (phoneNumber) =>
          context.read<SignUpCubit>().phoneNumberChanged(phoneNumber),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'phone number',
        helperText: '',
        errorText: displayError != null ? 'invalid phone number' : null,
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.email.displayError,
    );

    return TextField(
      key: const Key('signUpForm_emailInput_textField'),
      onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
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
      (SignUpCubit cubit) => cubit.state.password.displayError,
    );

    return TextField(
      key: const Key('signUpForm_passwordInput_textField'),
      onChanged: (password) =>
          context.read<SignUpCubit>().passwordChanged(password),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'password',
        helperText: '',
        errorText: displayError != null ? 'invalid password' : null,
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.select((SignUpCubit cubit) => cubit.state);

    final displayError = state.isConfirmedPasswordDirty
        ? state.confirmedPassword.displayError
        : null;

    return TextField(
      key: const Key('signUpForm_confirmedPasswordInput_textField'),
      onChanged: (confirmPassword) =>
          context.read<SignUpCubit>().confirmedPasswordChanged(confirmPassword),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'confirm password',
        helperText: '',
        errorText: displayError != null ? 'passwords do not match' : null,
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (SignUpCubit cubit) => cubit.state.status.isInProgress,
    );

    if (isInProgress) return const CircularProgressIndicator();

    final isValid = context.select((SignUpCubit cubit) => cubit.state.isValid);

    return ElevatedButton(
      key: const Key('signUpForm_continue_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.orangeAccent,
      ),
      onPressed: isValid ? () {} : null,
      child: const Text('SIGN UP'),
    );
  }
}
