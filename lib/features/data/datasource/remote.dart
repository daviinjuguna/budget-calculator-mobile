import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/errors/handle_call.dart';
import 'package:sortika_budget_calculator/features/data/api/api.dart';
import 'package:sortika_budget_calculator/features/data/response/auth_response.dart';
import 'package:sortika_budget_calculator/features/domain/model/profile_model.dart';
import 'package:sortika_budget_calculator/features/domain/model/user_model.dart';

abstract class RemoteDataSource {
  Future<AuthResponse> login({required String phone, required String password});
  Future<AuthResponse> register(
      {required String phone, required String password, String? name});
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
}
