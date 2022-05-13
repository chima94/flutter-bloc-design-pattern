import 'package:auth_repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_input/form_input.dart';
import 'package:formz/formz.dart';
import 'package:todo/sign_up/bloc/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepo) : super(const SignUpState());
  final AuthRepo _authRepo;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmPassword = ConfirmedPassword.dirty(
        password: password.value, value: state.confirmedPassword.value);
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmPassword,
      status: Formz.validate([
        state.email,
        password,
        confirmPassword,
      ]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.email,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(
      state.copyWith(
        status: FormzStatus.submissionInProgress,
      ),
    );
    try {
      await _authRepo.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
        ),
      );
    } on AuthError catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.dialogText,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
        ),
      );
    }
  }
}
