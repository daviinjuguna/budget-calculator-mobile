// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../../features/presentation/pages/auth/login_page.dart' as _i4;
import '../../features/presentation/pages/home/home_page.dart' as _i5;
import '../../features/presentation/pages/home/page/budget.dart' as _i6;
import '../../features/presentation/pages/home/page/expense.dart' as _i8;
import '../../features/presentation/pages/home/page/income.dart' as _i7;
import '../../features/presentation/pages/home/page/profile.dart' as _i9;
import '../../features/presentation/pages/splash/splash_page.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i3.SplashPage();
        }),
    LoginPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<LoginPageRouteArgs>(
              orElse: () => const LoginPageRouteArgs());
          return _i4.LoginPage(key: args.key);
        }),
    HomePageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i5.HomePage();
        }),
    Planner.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i6.BudgetPage();
        }),
    Income.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i7.IncomePage();
        }),
    Expense.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i8.ExpensePage();
        }),
    Profile.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i9.ProfilePage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashPageRoute.name, path: '/'),
        _i1.RouteConfig(LoginPageRoute.name, path: 'login'),
        _i1.RouteConfig(HomePageRoute.name, path: 'home', children: [
          _i1.RouteConfig(Planner.name, path: ''),
          _i1.RouteConfig(Income.name, path: 'income'),
          _i1.RouteConfig(Expense.name, path: 'expense'),
          _i1.RouteConfig(Profile.name, path: 'profile'),
          _i1.RouteConfig('*#redirect',
              path: '*', redirectTo: '', fullMatch: true)
        ])
      ];
}

class SplashPageRoute extends _i1.PageRouteInfo {
  const SplashPageRoute() : super(name, path: '/');

  static const String name = 'SplashPageRoute';
}

class LoginPageRoute extends _i1.PageRouteInfo<LoginPageRouteArgs> {
  LoginPageRoute({_i2.Key? key})
      : super(name, path: 'login', args: LoginPageRouteArgs(key: key));

  static const String name = 'LoginPageRoute';
}

class LoginPageRouteArgs {
  const LoginPageRouteArgs({this.key});

  final _i2.Key? key;
}

class HomePageRoute extends _i1.PageRouteInfo {
  const HomePageRoute({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'home', initialChildren: children);

  static const String name = 'HomePageRoute';
}

class Planner extends _i1.PageRouteInfo {
  const Planner() : super(name, path: '');

  static const String name = 'Planner';
}

class Income extends _i1.PageRouteInfo {
  const Income() : super(name, path: 'income');

  static const String name = 'Income';
}

class Expense extends _i1.PageRouteInfo {
  const Expense() : super(name, path: 'expense');

  static const String name = 'Expense';
}

class Profile extends _i1.PageRouteInfo {
  const Profile() : super(name, path: 'profile');

  static const String name = 'Profile';
}
