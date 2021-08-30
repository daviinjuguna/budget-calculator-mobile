import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/errors/map_exeption.dart';
import 'package:sortika_budget_calculator/features/data/datasource/local.dart';
import 'package:sortika_budget_calculator/features/data/datasource/remote.dart';

abstract class Repository {
  Future<Either<String, String>> login(
      {required String phone, required String pass});
  Future<Either<String, String>> register(
      {required String phone, required String pass, String? name});
  Future<Either<String, bool>> checkAuth();
}

@LazySingleton(as: Repository)
class RepositoryImpl implements Repository {
  final RemoteDataSource _remote;
  final LocalDataSource _local;

  RepositoryImpl(this._remote, this._local);

  @override
  Future<Either<String, String>> login(
      {required String phone, required String pass}) async {
    try {
      final _res = await _remote.login(phone: phone, password: pass);
      if (_res.error != null && _res.error!.length != 0)
        return left(_res.error!);

      await _local.saveTokens(_res.token);

      return right("Login Success");
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }

  @override
  Future<Either<String, String>> register(
      {required String phone, required String pass, String? name}) async {
    try {
      final _res =
          await _remote.register(phone: phone, password: pass, name: name);
      if (_res.error != null && _res.error!.length != 0)
        return left(_res.error!);

      await _local.saveTokens(_res.token);

      return right("Login Success");
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }

  @override
  Future<Either<String, bool>> checkAuth() async {
    try {
      final _res = await _local.fetchTokens();

      return right(_res != null);
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }
}
