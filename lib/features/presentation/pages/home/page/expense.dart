import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/expense/expense_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/components/expense_dialog.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      BlocProvider.of<ExpenseBloc>(context).add(GetExpenseEvent());
    });
  }

  List<ExpenseModel> _expense = [];
  late Completer<void> _completer = Completer();
  double _totalExpense = 0.0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      key: ValueKey("expense"),
      listeners: [
        BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            if (state is ExpenseInitial) {
              ScaffoldMessenger.maybeOf(context)?..hideCurrentSnackBar();
            }
            if (state is ExpenseUpdating) {
              ScaffoldMessenger.maybeOf(context)
                ?..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    )),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("LOADING..."),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).colorScheme.background),
                        )
                      ],
                    ),
                  ),
                );
            }
            if (state is ExpenseSuccess) {
              ScaffoldMessenger.maybeOf(context)?..hideCurrentSnackBar();
              _expense = state.expense;
              _totalExpense = state.total;
              _completer.complete();
              _completer = Completer();
            }
            if (state is ExpenseError) {
              ScaffoldMessenger.maybeOf(context)?..hideCurrentSnackBar();
              _completer.complete();
              _completer = Completer();
            }
          },
        )
      ],
      child: Column(),
    );
  }
}
