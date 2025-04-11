import 'package:formz/formz.dart';

/// Validation errors [FormzInput].
enum ValidationError {
  /// Generic invalid error.
  invalid,
}

// Username class extends FormzInput to handle username validation.
// It ensures the username starts with a letter, contains only letters,
// numbers, underscores, or dots, and has at least 4 characters.
class Username extends FormzInput<String, ValidationError> {
  // Constructor for pure Username input, representing an unmodified input.
  const Username.pure() : super.pure('');

  // Constructor for dirty Username input, representing a modified input.
  const Username.dirty([super.value = '']) : super.dirty();

  // Regular expression to validate username criteria.
  static final _usernameRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9_.]{3,}$');

  @override
  ValidationError? validator(String? value) {
    // Check if the value matches the username criteria.
    return _usernameRegExp.hasMatch(value ?? '')
        ? null
        : ValidationError.invalid;
  }
}

// PhoneNumber class extends FormzInput to handle phone number validation.
// It checks if the number starts with '0' and has exactly 10 digits.
class PhoneNumber extends FormzInput<String, ValidationError> {
  // Constructor for pure PhoneNumber input, representing an unmodified input.
  const PhoneNumber.pure() : super.pure('');

  // Constructor for dirty PhoneNumber input, representing a modified input.
  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  // Regular expression to validate phone number format (e.g., 0981234567).
  static final _phoneRegExp = RegExp(r'^0\d{9}$');

  @override
  ValidationError? validator(String? value) {
    // Check if the value matches the phone number format.
    return _phoneRegExp.hasMatch(value ?? '') ? null : ValidationError.invalid;
  }
}

// FullName class extends FormzInput to handle full name validation.
// It checks for at least two words, each with a minimum of 2 letters,
// using alphabetic characters only (including Vietnamese accents).
class FullName extends FormzInput<String, ValidationError> {
  // Constructor for pure FullName input, representing an unmodified input.
  const FullName.pure() : super.pure('');

  // Constructor for dirty FullName input, representing a modified input.
  const FullName.dirty([super.value = '']) : super.dirty();

  // Regular expression to validate full name structure.
  static final _fullNameRegExp = RegExp(
    r'^[A-Za-zÀ-ỹà-ỹ]{2,}(?: [A-Za-zÀ-ỹà-ỹ]{2,})+$',
  );

  @override
  ValidationError? validator(String? value) {
    // Check if the value matches the full name criteria.
    return _fullNameRegExp.hasMatch(value?.trim() ?? '')
        ? null
        : ValidationError.invalid;
  }
}

// The Email class is a form input validation class for email fields.
// It extends FormzInput with a String value and a ValidationError type.
class Email extends FormzInput<String, ValidationError> {
  // Constructor for an unmodified or "pure" email input.
  const Email.pure() : super.pure('');

  // Constructor for a modified or "dirty" email input.
  const Email.dirty([super.value = '']) : super.dirty();

  // Regular expression to validate the email format.
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  // Validator method to check if the email format is valid.
  @override
  ValidationError? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '') ? null : ValidationError.invalid;
  }
}

// Password class extends FormzInput to handle password validation.
// It uses a regular expression to ensure passwords contain at least
// one letter, one number, and are at least 8 characters long.
class Password extends FormzInput<String, ValidationError> {
  // Constructor for pure Password input, representing an unmodified input.
  const Password.pure() : super.pure('');

  // Constructor for dirty Password input, representing a modified input.
  const Password.dirty([super.value = '']) : super.dirty();

  // Regular expression to validate password criteria.
  static final _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  @override
  ValidationError? validator(String? value) {
    // Check if the value matches the password criteria.
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : ValidationError.invalid;
  }
}

// ConfirmedPassword class extends FormzInput to handle password confirmation validation.
// It ensures that the confirmed password matches the original password.
class ConfirmedPassword extends FormzInput<String, ValidationError> {
  // Constructor for pure ConfirmedPassword input, representing an unmodified input.
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  // Constructor for dirty ConfirmedPassword input, representing a modified input.
  const ConfirmedPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  // The original password to compare against.
  final String password;

  // Validator method to check if the confirmed password matches the original password.
  @override
  ValidationError? validator(String? value) {
    return password == value ? null : ValidationError.invalid;
  }
}
