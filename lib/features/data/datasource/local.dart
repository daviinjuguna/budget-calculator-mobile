import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortika_budget_calculator/core/errors/exeptions.dart';
import 'package:sortika_budget_calculator/core/utils/constants.dart';

abstract class LocalDataSource {
  Future<bool?> saveTokens(String token);
  Future<String?> fetchTokens();
  Future<bool> clearPrefs();
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences _prefs;

  LocalDataSourceImpl(this._prefs);

  @override
  Future<bool?> saveTokens(String token) async =>
      _prefs.setString(ACCESS_TOKENS, token);

  @override
  Future<String?> fetchTokens() async => _prefs.getString(ACCESS_TOKENS);

  @override
  Future<bool> clearPrefs() =>
      _prefs.clear().then((value) => value).onError((error, stackTrace) {
        print("Clear Prefs Error: $error");
        throw CacheException();
      });
}
