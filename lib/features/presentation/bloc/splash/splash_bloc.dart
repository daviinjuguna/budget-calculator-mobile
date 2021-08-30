import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/check_auth.dart';

part 'splash_event.dart';
part 'splash_state.dart';

@lazySingleton
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(this._auth) : super(SplashInitial());
  final CheckAuth _auth;

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is CheckSplashEvent) {
      yield SplashLoading();
      final _res = await _auth.call(NoParams());
      yield _res.fold(
        (l) => SplashLoggedOut(),
        (auth) {
          if (auth) return SplashLoggedIn();
          return SplashLoggedOut();
        },
      );
    }
  }
}
