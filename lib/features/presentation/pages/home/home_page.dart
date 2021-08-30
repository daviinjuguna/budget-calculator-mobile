import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/core/routes/app_router.gr.dart';
import 'package:sortika_budget_calculator/di/injection.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/expense/expense_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/income/income_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _incomeBloc = getIt<IncomeBloc>();
  late final _expenseBloc = getIt<ExpenseBloc>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _incomeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final _textTheme = Theme.of(context).textTheme;
    final _colorScheme = Theme.of(context).colorScheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _incomeBloc),
        BlocProvider(create: (create) => _expenseBloc),
      ],
      child: AutoTabsScaffold(
        routes: [
          Budget(),
          Income(),
          Expense(),
          Profile(),
        ],
        animationCurve: Curves.easeInCubic,
        builder: (context, child, animation) => Scaffold(
          body: FadeTransition(
            opacity: animation,
            // the passed child is techinaclly our animated selected-tab page
            child: child,
          ),
        ),
        appBarBuilder: (_, router) => AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            context.topRoute.name,
            style: _textTheme.headline4?.copyWith(color: _colorScheme.primary),
          ),
        ),
        bottomNavigationBuilder: (context, router) => BottomNavigationBar(
          currentIndex: router.activeIndex,
          type: BottomNavigationBarType.fixed,
          onTap: router.setActiveIndex,
          // backgroundColor: Colors.black,
          // selectedItemColor: Colors.white,
          // unselectedItemColor: Colors.white70,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.price_check), label: "Budget"),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), label: "Income"),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: "Expense",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
