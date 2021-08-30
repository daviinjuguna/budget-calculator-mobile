// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import '../core/errors/handle_call.dart' as _i4;
import '../features/data/api/api.dart' as _i3;
import '../features/data/datasource/local.dart' as _i7;
import '../features/data/datasource/remote.dart' as _i5;
import '../features/data/repo/repository.dart' as _i8;
import '../features/domain/usecase/check_auth.dart' as _i9;
import '../features/domain/usecase/create_expense.dart' as _i10;
import '../features/domain/usecase/create_income.dart' as _i11;
import '../features/domain/usecase/delete_expense.dart' as _i12;
import '../features/domain/usecase/delete_income.dart' as _i13;
import '../features/domain/usecase/edit_expense.dart' as _i14;
import '../features/domain/usecase/edit_income.dart' as _i15;
import '../features/domain/usecase/get_expense.dart' as _i16;
import '../features/domain/usecase/get_income.dart' as _i17;
import '../features/domain/usecase/login.dart' as _i19;
import '../features/domain/usecase/register.dart' as _i20;
import '../features/presentation/bloc/auth/auth_bloc.dart' as _i22;
import '../features/presentation/bloc/expense/expense_bloc.dart' as _i23;
import '../features/presentation/bloc/income/income_bloc.dart' as _i18;
import '../features/presentation/bloc/splash/splash_bloc.dart' as _i21;
import 'module_injection.dart' as _i24; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final injectionModules = _$InjectionModules();
  gh.lazySingleton<_i3.Api>(() => _i3.ApiImpl());
  gh.lazySingleton<_i4.HandleNetworkCall>(() => _i4.HandleNetworkCall());
  gh.lazySingleton<_i5.RemoteDataSource>(() =>
      _i5.RemoteDataSourceImpl(get<_i3.Api>(), get<_i4.HandleNetworkCall>()));
  await gh.factoryAsync<_i6.SharedPreferences>(() => injectionModules.prefs,
      preResolve: true);
  gh.lazySingleton<_i7.LocalDataSource>(
      () => _i7.LocalDataSourceImpl(get<_i6.SharedPreferences>()));
  gh.lazySingleton<_i8.Repository>(() => _i8.RepositoryImpl(
      get<_i5.RemoteDataSource>(), get<_i7.LocalDataSource>()));
  gh.lazySingleton<_i9.CheckAuth>(() => _i9.CheckAuth(get<_i8.Repository>()));
  gh.lazySingleton<_i10.CreateExpense>(
      () => _i10.CreateExpense(get<_i8.Repository>()));
  gh.lazySingleton<_i11.CreateIncome>(
      () => _i11.CreateIncome(get<_i8.Repository>()));
  gh.lazySingleton<_i12.DeleteExpense>(
      () => _i12.DeleteExpense(get<_i8.Repository>()));
  gh.lazySingleton<_i13.DeleteIncome>(
      () => _i13.DeleteIncome(get<_i8.Repository>()));
  gh.lazySingleton<_i14.EditExpense>(
      () => _i14.EditExpense(get<_i8.Repository>()));
  gh.lazySingleton<_i15.EditIncome>(
      () => _i15.EditIncome(get<_i8.Repository>()));
  gh.lazySingleton<_i16.GetExpense>(
      () => _i16.GetExpense(get<_i8.Repository>()));
  gh.lazySingleton<_i17.GetIncome>(() => _i17.GetIncome(get<_i8.Repository>()));
  gh.factory<_i18.IncomeBloc>(() => _i18.IncomeBloc(
      get<_i17.GetIncome>(),
      get<_i11.CreateIncome>(),
      get<_i15.EditIncome>(),
      get<_i13.DeleteIncome>()));
  gh.lazySingleton<_i19.Login>(() => _i19.Login(get<_i8.Repository>()));
  gh.lazySingleton<_i20.Register>(() => _i20.Register(get<_i8.Repository>()));
  gh.lazySingleton<_i21.SplashBloc>(
      () => _i21.SplashBloc(get<_i9.CheckAuth>()));
  gh.lazySingleton<_i22.AuthBloc>(
      () => _i22.AuthBloc(get<_i19.Login>(), get<_i20.Register>()));
  gh.factory<_i23.ExpenseBloc>(() => _i23.ExpenseBloc(
      get<_i16.GetExpense>(),
      get<_i10.CreateExpense>(),
      get<_i14.EditExpense>(),
      get<_i12.DeleteExpense>()));
  return get;
}

class _$InjectionModules extends _i24.InjectionModules {}
