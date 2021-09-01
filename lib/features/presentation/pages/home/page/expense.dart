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
    ExpenseModel.defaultExpense(expense: "Housing", amount: 22.5),
    ExpenseModel.defaultExpense(expense: "Food & Shopping", amount: 15.0),
    ExpenseModel.defaultExpense(expense: "Savings & Investment", amount: 17.0),
    ExpenseModel.defaultExpense(
        expense: "Faith & Church/Charity", amount: 12.0),
    ExpenseModel.defaultExpense(expense: "Transport", amount: 10.0),
    ExpenseModel.defaultExpense(expense: "Utilities", amount: 5.0),
    ExpenseModel.defaultExpense(expense: "Clothing", amount: 5.0),
    ExpenseModel.defaultExpense(
        expense: "Personal Care & Wellness", amount: 6.0),
    ExpenseModel.defaultExpense(expense: "Entertainment", amount: 7.0),
  ];
  List<ExpenseModel> _expense = [];
  late Completer<void> _completer = Completer();
  double _totalExpense = 0.0;
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
            _totalExpense = state.total;
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
                          BlocProvider.of<ExpenseBloc>(context)
                              .add(CreateExpenseEvent(
                            list: _expense,
                            model: value,
                            total: _totalExpense,
                          ));
                          //     CreateIncomeEvent(
                          //         total: _total, list: _income, model: value));
                        }
                      }),
                      child: Text("Add Expense"),
                    ),
                    TextButton(
                        onPressed: () => showDialog<ExpenseModel?>(
                              context: context,
                              builder: (builder) => SuggestedDialog(
                                expense: _defaultExpense,
                              ),
                            ).then((value) {
                              if (value != null) {
                                BlocProvider.of<ExpenseBloc>(context).add(
                                    CreateExpenseEvent(
                                        total: _totalExpense,
                                        list: _expense,
                                        model: value));
                              }
                            }),
                        child: Text("Add Suggested Expense"))
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
                                  Text("KES ${_expense[i].ammount}"),

                                  SizedBox(
                                    height: 3,
                                  ),

                                  _expense[i].isStatic
                                      ? Text("Fixed")
                                      : Text("Adjustable")

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
                                          initial: _expense[i],
                                          model: value,
                                          total: _totalExpense,
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
                                                total: _totalExpense,
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

class SuggestedDialog extends StatefulWidget {
  final List<ExpenseModel> _expense;
  const SuggestedDialog({
    Key? key,
    required List<ExpenseModel> expense,
  })  : _expense = expense,
        super(key: key);

  @override
  _SuggestedDialogState createState() => _SuggestedDialogState();
}

class _SuggestedDialogState extends State<SuggestedDialog> {
  List<TextEditingController> _ammount = [];
  @override
  void initState() {
    _ammount = widget._expense.map((e) => TextEditingController()).toList();
    super.initState();
  }

  @override
  void dispose() {
    _ammount.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("SUGGESTED EXPENSES"),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        child: ListView.builder(
          itemCount: widget._expense.length,
          itemBuilder: (c, i) => Card(
            child: ListTile(
              title: Text(widget._expense[i].expense),
              subtitle: Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextField(
                  onChanged: (value) {},
                  controller: _ammount[i],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Enter Amount"),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  if (_ammount[i].text.isNotEmpty) {
                    Navigator.of(context).pop(widget._expense[i].copyWith(
                        ammount: double.parse(_ammount[i].text.trim())));
                  }
                },
                color: Colors.green,
                icon: Icon(Icons.check),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
