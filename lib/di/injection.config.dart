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
import '../features/domain/usecase/login.dart' as _i10;
import '../features/domain/usecase/register.dart' as _i11;
import '../features/presentation/bloc/auth/auth_bloc.dart' as _i13;
import '../features/presentation/bloc/splash/splash_bloc.dart' as _i12;
import 'module_injection.dart' as _i14; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i10.Login>(() => _i10.Login(get<_i8.Repository>()));
  gh.lazySingleton<_i11.Register>(() => _i11.Register(get<_i8.Repository>()));
  gh.lazySingleton<_i12.SplashBloc>(
      () => _i12.SplashBloc(get<_i9.CheckAuth>()));
  gh.lazySingleton<_i13.AuthBloc>(
      () => _i13.AuthBloc(get<_i10.Login>(), get<_i11.Register>()));
  return get;
}

class _$InjectionModules extends _i14.InjectionModules {}
