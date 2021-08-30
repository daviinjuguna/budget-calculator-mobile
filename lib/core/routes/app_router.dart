import 'package:auto_route/auto_route.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/auth/login_page.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/home_page.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/splash/splash_page.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: LoginPage, path: "login"),
    MaterialRoute(page: HomePage, path: "home")
  ],
)
class $AppRouter {}
