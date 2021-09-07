import 'package:auto_route/auto_route.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/auth/login_page.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/home_page.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/page/budget.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/page/expense.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/page/income.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/page/profile.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/splash/splash_page.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: LoginPage, path: "login"),
    MaterialRoute(
      page: HomePage,
      path: "home",
      children: [
        MaterialRoute(page: BudgetPage, path: "", name: "Planner"),
        MaterialRoute(page: IncomePage, path: "income", name: "Income"),
        MaterialRoute(page: ExpensePage, path: "expense", name: "Expense"),
        MaterialRoute(page: ProfilePage, path: "profile", name: "Profile"),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    )
  ],
)
class $AppRouter {}
