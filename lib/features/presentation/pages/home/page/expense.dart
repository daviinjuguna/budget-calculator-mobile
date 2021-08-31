import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/expense/expense_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/components/custom_switch.dart';
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

  List<ExpenseModel> _defaultExpense = [
    ExpenseModel.defaultExpense(expense: "Housing", percent: 22.5),
    ExpenseModel.defaultExpense(expense: "Food & Shopping", percent: 15.0),
    ExpenseModel.defaultExpense(expense: "Savings & Investment", percent: 17.0),
    ExpenseModel.defaultExpense(
        expense: "Faith & Church/Charity", percent: 12.0),
    ExpenseModel.defaultExpense(expense: "Transport", percent: 10.0),
    ExpenseModel.defaultExpense(expense: "Utilities", percent: 5.0),
    ExpenseModel.defaultExpense(expense: "Clothing", percent: 5.0),
    ExpenseModel.defaultExpense(
        expense: "Personal Care & Wellness", percent: 6.0),
    ExpenseModel.defaultExpense(expense: "Entertainment", percent: 7.0),
  ];
  List<ExpenseModel> _expense = [];
  late Completer<void> _completer = Completer();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey("expense"),
      child: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseSuccess) {
            _expense = state.expense;

            _completer.complete();
            _completer = Completer();
          }
          if (state is ExpenseError) {
            _completer.complete();
            _completer = Completer();
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => showDialog<ExpenseModel?>(
                        context: context,
                        builder: (builder) => ExpenseDialog(),
                      ).then((value) {
                        if (value != null) {
                          BlocProvider.of<ExpenseBloc>(context).add(
                              CreateExpenseEvent(list: _expense, model: value));
                          //     CreateIncomeEvent(
                          //         total: _total, list: _income, model: value));
                        }
                      }),
                      child: Text("Add Expense"),
                    ),
                    TextButton(
                        onPressed: () => showDialog<bool?>(
                              context: context,
                              builder: (builder) => AlertDialog(
                                title: Text("ADD DEFAULT EXPENSE"),
                                content: Text(
                                    "Are you sure you want to add default expense?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(null),
                                    child: Text(
                                      "CANCEL",
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text(
                                      "OK",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ).then((value) {
                              if (value != null && value) {
                                for (int i = 0;
                                    i < _defaultExpense.length;
                                    i++) {
                                  BlocProvider.of<ExpenseBloc>(context).add(
                                      CreateExpenseEvent(
                                          list: _expense
                                            ..add(_defaultExpense[i]),
                                          model: _defaultExpense[i]));
                                }
                              }
                            }),
                        child: Text("Add Default Expense"))
                  ],
                ),
              ),
              Expanded(
                child: (state is ExpenseLoading)
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () {
                          BlocProvider.of<ExpenseBloc>(context)
                              .add(RefreshExpenseEvent());
                          return _completer.future;
                        },
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _expense.length,
                          itemBuilder: (_, i) => Card(
                            child: ListTile(
                              title: Text(_expense[i].expense),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _expense[i].isStatic
                                      ? Text("KES ${_expense[i].ammount}")
                                      : Text(
                                          "${_expense[i].percentageAmmount ?? ""} %"),
                                  SizedBox(
                                    height: 3,
                                  ),

                                  // CustomSwitch(
                                  //   value: _expense[i].isStatic,
                                  //   onChanged: (value) => showDialog<bool?>(
                                  //     context: context,
                                  //     builder: (builder) => AlertDialog(
                                  //       title: Text("Change to"),
                                  //       content: Text(
                                  //           "Are you sure you want to change?"),
                                  //       actions: [
                                  //         TextButton(
                                  //           onPressed: () =>
                                  //               Navigator.of(context).pop(null),
                                  //           child: Text(
                                  //             "CANCEL",
                                  //           ),
                                  //         ),
                                  //         TextButton(
                                  //           onPressed: () =>
                                  //               Navigator.of(context).pop(true),
                                  //           child: Text(
                                  //             "OK",
                                  //             style: TextStyle(
                                  //                 color: Colors.green),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ).then((value) {
                                  //     if (value != null && value) {}

                                  //   }),
                                  // )
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => showDialog<ExpenseModel?>(
                                      context: context,
                                      builder: (builder) => ExpenseDialog(
                                        expense: _expense[i],
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        BlocProvider.of<ExpenseBloc>(context)
                                            .add(EditExpenseEvent(
                                          list: _expense,
                                          model: _expense[i],
                                          index: i,
                                        ));

                                        print(value);
                                      }
                                    }),
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () => showDialog<bool?>(
                                      context: context,
                                      builder: (builder) => AlertDialog(
                                        title: Text("DELETE"),
                                        content: Text(
                                            "Are you sure you want to delete?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(null),
                                            child: Text(
                                              "CANCEL",
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text(
                                              "DELETE",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).then((value) {
                                      if (value != null && value) {
                                        BlocProvider.of<ExpenseBloc>(context)
                                            .add(DeleteExpenseEvent(
                                                list: _expense,
                                                model: _expense[i]));
                                      }
                                    }),
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}
