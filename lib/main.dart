import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sortika_budget_calculator/core/utils/bloc_observer.dart';
import 'package:sortika_budget_calculator/core/utils/constants.dart';
import 'package:sortika_budget_calculator/core/utils/themes.dart';
import 'package:sortika_budget_calculator/di/injection.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/splash/splash_bloc.dart';
import 'package:telephony/telephony.dart';

import 'core/routes/app_router.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  await configureInjection(environment: DEVELOPMENT);
  handleSms();
  runApp(MyApp());
}

void handleSms() {
  Telephony.instance.listenIncomingSms(
      onNewMessage: (SmsMessage sms) {
        print(sms.address);
        print(sms.body);
        print(sms.subject);
        print(sms.type);
      },
      listenInBackground: false);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  late final _navKey = GlobalKey<NavigatorState>();
  late final _appRouter = AppRouter(_navKey);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => getIt<SplashBloc>())],
      child: MaterialApp.router(
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate(),
        title: 'Budget Calculator',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green,
          brightness: Brightness.light,
          textTheme: defaultTextTheme,
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: defaultColorScheme.primary,
            elevation: 0,
            centerTitle: true,
            textTheme:
                defaultTextTheme.apply(bodyColor: defaultColorScheme.onPrimary),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          colorScheme: defaultColorScheme,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: const {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              enableFeedback: true,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              gapPadding: 2,
            ),
          ),
        ),
      ),
    );
  }
}
