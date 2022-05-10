import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthOperationNotAllowed(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
  'wrong-password': AuthErrorInvalidCredential()
};

@immutable
abstract class AuthError implements Exception{
  final String dialogTitle;
  final String dialogText;

  const AuthError({required this.dialogTitle, required this.dialogText});

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnknown();

  factory AuthError.unknown() => const AuthErrorUnknown();
}



@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
            dialogText: 'Unknown authentication error',
            dialogTitle: 'Authentication error');
}

@immutable
class AuthErrorInvalidCredential extends AuthError {
  const AuthErrorInvalidCredential()
      : super(
            dialogText: 'Email or password not correct',
            dialogTitle: 'Invalid credential');
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
            dialogText: 'No current user!',
            dialogTitle: 'No current user with this information was found!');
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
            dialogText: 'Requires recent login!',
            dialogTitle:
                'You need to log out and back in again in order to perform this operation!');
}

@immutable
class AuthOperationNotAllowed extends AuthError {
  const AuthOperationNotAllowed()
      : super(
            dialogText: 'Operation not allowed!',
            dialogTitle:
                'You cannot register using this method at this moment!');
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
            dialogText: 'User not found!',
            dialogTitle: 'The given user was not found on the server!');
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
            dialogText: 'Weak Password',
            dialogTitle:
                'Please choose a stronger password consisting of more characters!');
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
            dialogText: 'Invalid email',
            dialogTitle: 'Please double check your email and try again!');
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
            dialogText: 'Email already in use',
            dialogTitle: 'Please choose another email to register with!');
}
