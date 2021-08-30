import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectionModules {
  //*shared preferences for cache storage
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  //*check connectivity of the phone
  // @lazySingleton
  // Connectivity get connectivity => Connectivity();
}
