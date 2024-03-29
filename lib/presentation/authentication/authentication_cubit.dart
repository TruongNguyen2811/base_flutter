import 'dart:async';

import 'package:code_base/services/preferences/app_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:injectable/injectable.dart';

import '../../injection_container.dart';
import '../../services/repository/app_repository_impl.dart';
import '../../utils/enum.dart';
import '../../utils/utils.dart';
import 'authentication_state.dart';

@LazySingleton()
class AppCubit extends Cubit<AppState> {
  final AppPreferences _pref = getIt<AppPreferences>();
  AppRepository repository = AppRepository();

  bool get isLoggedIn => _pref.isLoggedIn;

  AppCubit() : super(AuthenticationUninitialized());

  void openApp() {
    emit(AuthenticationUninitialized());
    Future.delayed(
      const Duration(milliseconds: 3500),
      () {
        if (isLoggedIn) {
          emit(AuthenticationAuthenticated());
          return;
        }
        emit(const AuthenticationUnauthenticated());
      },
    );
  }

  void login() {
    emit(AuthenticationLoading());
    emit(AuthenticationAuthenticated());
  }

  void logout({String? errorMessage}) async {
    emit(AuthenticationLoading());
    // getIt<MainCubit>().logout();

    _pref.logout();
    emit(AuthenticationUnauthenticated(errorMessage: errorMessage));
  }

  void navigateResetToSignIn() {
    emit(AuthenticationLoading());
    emit(const AuthenticationUnauthenticated());
  }

  void showError(String error) {
    AppState currentState = state;
    emit(ErrorState(error: error));
    emit(currentState);
  }

  void showMessage(String message, {ToastType messageType = ToastType.INFORM}) {
    emit(MessageState(message, messageType));
    emit(AuthenticationInitial());
  }
}
