import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/errors/exeptions.dart';
import 'package:sortika_budget_calculator/core/errors/handle_call.dart';
import 'package:sortika_budget_calculator/features/data/api/api.dart';
import 'package:sortika_budget_calculator/features/data/response/auth_response.dart';
import 'package:sortika_budget_calculator/features/data/response/expense_response.dart';
import 'package:sortika_budget_calculator/features/data/response/income_response.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';
import 'package:sortika_budget_calculator/features/domain/model/profile_model.dart';
import 'package:sortika_budget_calculator/features/domain/model/user_model.dart';

abstract class RemoteDataSource {
  Future<AuthResponse> login({required String phone, required String password});
  Future<AuthResponse> register(
      {required String phone, required String password, String? name});

  Future<IncomeResponse> getIncome();
  Future<IncomeResponse> createIncome(IncomeModel model);
  Future<IncomeResponse> editIncome(IncomeModel model);
  Future<String> deleteIncome(IncomeModel model);

  Future<ExpenseResponse> getExpense();
  Future<ExpenseResponse> createExpense(ExpenseModel model);
  Future<ExpenseResponse> editExpense(ExpenseModel model);
  Future<String> deleteExpense(ExpenseModel model);
}

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final Api _api;
  final HandleNetworkCall _call;

  RemoteDataSourceImpl(this._api, this._call);

  @override
  Future<AuthResponse> login(
      {required String phone, required String password}) async {
    try {
      final _res = await _api.login(phone: phone, password: password);
      late final Map<String, dynamic> _body = jsonDecode(_res.body);

      final _status = _call.checkStatusCode(_res.statusCode);
      if (_status) {
        return AuthResponse(
          user: UserModel.fromJson(_body['user']),
          profile: ProfileModel.fromJson(_body['profile']),
          token: _body['token'],
        );
      }
      return AuthResponse.withError(_res.body);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<AuthResponse> register(
      {required String phone, required String password, String? name}) async {
    try {
      final _res =
          await _api.register(phone: phone, password: password, name: name);
      late final Map<String, dynamic> _body = jsonDecode(_res.body);

      final _status = _call.checkStatusCode(_res.statusCode);
      if (_status) {
        return AuthResponse(
          user: UserModel.fromJson(_body['user']),
          profile: ProfileModel.fromJson(_body['profile']),
          token: _body['token'],
        );
      }
      return AuthResponse.withError(_res.body);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<IncomeResponse> getIncome() async {
    try {
      final _res = await _api.getIncomes();
      final _status = _call.checkStatusCode(_res.statusCode);
      late final Map<String, dynamic> _body = jsonDecode(_res.body);

      if (_status) {
        return IncomeResponse(
            (_body["income"] as List)
                .map((e) => IncomeModel.fromJson(e))
                .toList(),
            _body['total']);
      }
      return IncomeResponse.withError(_res.body);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<IncomeResponse> createIncome(IncomeModel model) async {
    try {
      final _res = await _api.createIncome(model);
      final _status = _call.checkStatusCode(_res.statusCode);
      late final Map<String, dynamic> _body = jsonDecode(_res.body);

      if (_status) {
        return IncomeResponse.single(IncomeModel.fromJson(_body["income"]));
      }
      return IncomeResponse.withError(_res.body);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<IncomeResponse> editIncome(IncomeModel model) async {
    try {
      final _res = await _api.editIncome(model);
      final _status = _call.checkStatusCode(_res.statusCode);
      late final Map<String, dynamic> _body = jsonDecode(_res.body);

      if (_status) {
        return IncomeResponse.single(IncomeModel.fromJson(_body["income"]));
      }
      return IncomeResponse.withError(_res.body);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<String> deleteIncome(IncomeModel model) async {
    try {
      final _res = await _api.deleteIncome(model);
      if (_res.statusCode == 204) {
        return "Deleted";
      }
      throw ServerException();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<ExpenseResponse> getExpense() async {
    try {
      final _res = await _api.getExpense();
      final _status = _call.checkStatusCode(_res.statusCode);
      late final Map<String, dynamic> _body = jsonDecode(_res.body);

      if (_status) {
        return ExpenseResponse((_body["expense"] as List)
            .map((e) => ExpenseModel.fromJson(e))
            .toList());
      }
      return ExpenseResponse.withError(_res.body);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<ExpenseResponse> createExpense(ExpenseModel model) async {
    try {
      final _res = await _api.createExpense(model);
      final _status = _call.checkStatusCode(_res.statusCode);
      late final Map<String, dynamic> _body = jsonDecode(_res.body);

      if (_status) {
        return ExpenseResponse.single(ExpenseModel.fromJson(_body["expense"]));
      }
      return ExpenseResponse.withError(_res.body);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<ExpenseResponse> editExpense(ExpenseModel model) async {
    try {
      final _res = await _api.editExpense(model);
      final _status = _call.checkStatusCode(_res.statusCode);
      late final Map<String, dynamic> _body = jsonDecode(_res.body);

      if (_status) {
        return ExpenseResponse.single(ExpenseModel.fromJson(_body["expense"]));
      }
      return ExpenseResponse.withError(_res.body);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<String> deleteExpense(ExpenseModel model) async {
    try {
      final _res = await _api.deleteExpense(model);
      if (_res.statusCode == 204) {
        return "Deleted";
      }
      throw ServerException();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
