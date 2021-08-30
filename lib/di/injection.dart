import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@injectableInit

/// This is how to initialize injectable class....
Future<void> configureInjection({String? environment}) async =>
    await $initGetIt(getIt, environment: environment);
