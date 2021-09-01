import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/errors/map_exeption.dart';
import 'package:sortika_budget_calculator/features/data/datasource/local.dart';
import 'package:sortika_budget_calculator/features/data/datasource/remote.dart';
import 'package:sortika_budget_calculator/features/data/response/expense_response.dart';
import 'package:sortika_budget_calculator/features/data/response/income_response.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';

abstract class Repository {
  Future<Either<String, String>> login(
      {required String phone, required String pass});
  Future<Either<String, String>> register(
      {required String phone, required String pass, String? name});
  Future<Either<String, bool>> checkAuth();

  Future<Either<String, IncomeResponse>> getIncome();
  Future<Either<String, IncomeModel>> createIncome(IncomeModel model);
  Future<Either<String, IncomeModel>> editIncome(IncomeModel model);
  Future<Either<String, String>> deleteIncome(IncomeModel model);

  Future<Either<String, ExpenseResponse>> getExpense();
  Future<Either<String, ExpenseModel>> createExpense(ExpenseModel model);
  Future<Either<String, ExpenseModel>> editExpense(ExpenseModel model);
  Future<Either<String, String>> deleteExpense(ExpenseModel model);
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

  @override
  Future<Either<String, IncomeResponse>> getIncome() async {
    try {
      final _res = await _remote.getIncome();
      if (_res.error != null && _res.error!.length != 0)
        return left(_res.error!);
      return right(_res);
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }

  @override
  Future<Either<String, IncomeModel>> createIncome(IncomeModel model) async {
    try {
      final _res = await _remote.createIncome(model);
      if (_res.error != null && _res.error!.length != 0)
        return left(_res.error!);
      return right(_res.singleIncome!);
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }

  @override
  Future<Either<String, IncomeModel>> editIncome(IncomeModel model) async {
    try {
      final _res = await _remote.editIncome(model);
      if (_res.error != null && _res.error!.length != 0)
        return left(_res.error!);
      return right(_res.singleIncome!);
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }

  @override
  Future<Either<String, String>> deleteIncome(IncomeModel model) async {
    try {
      return right(await _remote.deleteIncome(model));
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }

  @override
  Future<Either<String, ExpenseResponse>> getExpense() async {
    try {
      final _res = await _remote.getExpense();
      if (_res.error != null && _res.error!.length != 0)
        return left(_res.error!);
      return right(_res);
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }

  @override
  Future<Either<String, ExpenseModel>> createExpense(ExpenseModel model) async {
    try {
      final _res = await _remote.createExpense(model);
      if (_res.error != null && _res.error!.length != 0)
        return left(_res.error!);
      return right(_res.singleExpense!);
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }

  @override
  Future<Either<String, ExpenseModel>> editExpense(ExpenseModel model) async {
    try {
      final _res = await _remote.editExpense(model);
      if (_res.error != null && _res.error!.length != 0)
        return left(_res.error!);
      return right(_res.singleExpense!);
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }

  @override
  Future<Either<String, String>> deleteExpense(ExpenseModel model) async {
    try {
      return right(await _remote.deleteExpense(model));
    } catch (e) {
      print(e);
      return left(mapExeption(e));
    }
  }
}
