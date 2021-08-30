import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/login.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/register.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._login, this._register) : super(AuthInitial());
  final Login _login;
  final Register _register;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthLoginEvent) {
      yield AuthLoading();
      final _res =
          await _login.call(AuthParams(phone: event.phone, pass: event.pass));
      yield _res.fold((l) => AuthError(l), (r) => AuthSuccess());
    }
    if (event is AuthRegisterEvent) {
      yield AuthLoading();
      final _res = await _register.call(
          AuthParams(phone: event.phone, pass: event.pass, name: event.name));
      yield _res.fold((l) => AuthError(l), (r) => AuthSuccess());
    }
  }
}
