import 'dart:convert';

import 'package:http_interceptor/http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:sortika_budget_calculator/core/utils/constants.dart';
import 'package:sortika_budget_calculator/core/utils/intercepters.dart';

abstract class Api {
  Future<http.Response> login(
      {required String phone, required String password});

  Future<http.Response> register(
      {required String phone, required String password, String? name});
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
      Uri.http(BASE_URL, url, queryParameters);

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
}
