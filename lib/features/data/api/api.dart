import 'dart:convert';

import 'package:http_interceptor/http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:sortika_budget_calculator/core/utils/constants.dart';
import 'package:sortika_budget_calculator/core/utils/intercepters.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';

abstract class Api {
  Future<http.Response> login(
      {required String phone, required String password});

  Future<http.Response> register(
      {required String phone, required String password, String? name});

  Future<http.Response> getIncomes();
  Future<http.Response> createIncome(IncomeModel model);
  Future<http.Response> editIncome(IncomeModel model);
  Future<http.Response> deleteIncome(IncomeModel model);

  Future<http.Response> getExpense();
  Future<http.Response> createExpense(ExpenseModel model);
  Future<http.Response> editExpense(ExpenseModel model);
  Future<http.Response> deleteExpense(ExpenseModel model);
}

@LazySingleton(as: Api)
class ApiImpl implements Api {
  http.Client _client = InterceptedClient.build(
    interceptors: [
      HttpInterceptors(),
    ],
    requestTimeout: Duration(seconds: 60),
  );

  //*just add 's' to http to be secured url
  Uri appUrl(String url, [Map<String, dynamic>? queryParameters]) =>
      Uri.https(BASE_URL, url, queryParameters);

  @override
  Future<http.Response> login(
      {required String phone, required String password}) {
    final _url = "/user/login/";
    return _client.post(
      appUrl(_url),
      body: jsonEncode({"phone": phone, "password": password}),
    );
  }

  @override
  Future<http.Response> register(
      {required String phone, required String password, String? name}) {
    final _url = "/user/register/";
    return _client.post(
      appUrl(_url),
      body: jsonEncode({"phone": phone, "password": password, "name": name}),
    );
  }

  @override
  Future<http.Response> getIncomes() {
    final _url = '/user/income';
    return _client.get(appUrl(_url));
  }

  @override
  Future<http.Response> createIncome(IncomeModel model) {
    final _url = '/user/income/';
    return _client.post(appUrl(_url), body: jsonEncode(model.toJson()));
  }

  @override
  Future<http.Response> editIncome(IncomeModel model) {
    final _url = '/user/income/';
    return _client.put(appUrl(_url), body: jsonEncode(model.toJson()));
  }

  @override
  Future<http.Response> deleteIncome(IncomeModel model) {
    final _url = '/user/income/';
    return _client.delete(appUrl(_url, {"income_id": model.id.toString()}));
  }

  @override
  Future<http.Response> getExpense() {
    final _url = '/user/expense';
    return _client.get(appUrl(_url));
  }

  @override
  Future<http.Response> createExpense(ExpenseModel model) {
    final _url = '/user/expense/';
    return _client.post(appUrl(_url), body: jsonEncode(model.toJson()));
  }

  @override
  Future<http.Response> editExpense(ExpenseModel model) {
    final _url = '/user/expense/';
    return _client.put(appUrl(_url), body: jsonEncode(model.toJson()));
  }

  @override
  Future<http.Response> deleteExpense(ExpenseModel model) {
    final _url = '/user/expense/';
    return _client.delete(appUrl(_url, {"expense_id": model.id.toString()}));
  }
}
