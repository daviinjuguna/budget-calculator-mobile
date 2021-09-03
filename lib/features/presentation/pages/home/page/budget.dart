import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/core/utils/constants.dart';
import 'package:sortika_budget_calculator/core/utils/hex_converter.dart';

import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/expense/expense_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/income/income_bloc.dart';
import 'package:telephony/telephony.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage>
    with AutomaticKeepAliveClientMixin {
  late Completer<void> _completer = Completer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      BlocProvider.of<IncomeBloc>(context).add(GetIncomeEvent());
      // handleSms(context);
    });
  }

  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  double _newTotal = 0.0;

  double _loans = 0.0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  List<ExpenseModel> _expense = [];

  // List<ExpenseModel> _defaultExpense = [];
// Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)

  // List<IncomeModel> _incomes = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    late final _textTheme = Theme.of(context).textTheme;
    return MultiBlocListener(
      listeners: [
        BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            if (state is ExpenseInitial) {
              setState(() {
                _loans = 0.0;
              });
            }
            if (state is ExpenseSuccess) {
              _completer.complete();
              _completer = Completer();
              _expense = state.expense;
              _totalExpense = state.total;
              setState(() {
                _newTotal = state.total;
              });

              // print(_defaultExpense);
            }
            if (state is ExpenseError) {
              _completer.complete();
              _completer = Completer();
            }
          },
        ),
        BlocListener<IncomeBloc, IncomeState>(
          listener: (context, state) {
            if (state is IncomeSuccess) {
              BlocProvider.of<ExpenseBloc>(context).add(GetExpenseEvent());

              setState(() {
                _totalIncome = state.total;
              });
              _completer.complete();
              _completer = Completer();
            }
            if (state is IncomeError) {
              _completer.complete();
              _completer = Completer();
            }
          },
        )
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        key: ValueKey("budget"),
        child: RefreshIndicator(
          onRefresh: () {
            BlocProvider.of<IncomeBloc>(context).add(RefreshIncomeEvent());
            return _completer.future;
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  "Your Budget",
                  style: _textTheme.headline6?.copyWith(),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Income",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    BlocBuilder<IncomeBloc, IncomeState>(
                      builder: (context, state) {
                        return Text(
                          "KES $_totalIncome",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ],
                ),
                Divider(thickness: 1.5),
                BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    if (state is ExpenseLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (c, i) => SizedBox(height: 2),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _expense.length,
                      itemBuilder: (_, i) => Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  color: HexColor(_expense[i].color),
                                ),
                                SizedBox(width: 3),
                                Text(_expense[i].expense),
                              ],
                            ),
                            Text.rich(TextSpan(children: [
                              TextSpan(text: _expense[i].ammount.toString()),
                            ]))
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Expense",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    BlocBuilder<ExpenseBloc, ExpenseState>(
                      builder: (context, state) {
                        return Text(
                          "KES $_totalExpense",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Savings",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    BlocBuilder<ExpenseBloc, ExpenseState>(
                      builder: (context, state) {
                        return Text(
                          "KES ${_totalIncome - _totalExpense}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: (_totalIncome > _totalExpense)
                                ? Colors.green
                                : Colors.red,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "Recommended Budget",
                  style: _textTheme.headline6?.copyWith(),
                ),
                Divider(thickness: 1.5),
                BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    if (state is ExpenseLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (c, i) => SizedBox(height: 2),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _expense.length,
                      itemBuilder: (_, i) => Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  color: HexColor(_expense[i].color),
                                ),
                                SizedBox(width: 3),
                                Text(_expense[i].expense),
                              ],
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: _expense[i].recommended.toString() +
                                          "% " +
                                          " (" +
                                          _getAmmountFromPercentage(
                                                  _expense[i].recommended,
                                                  _totalIncome)
                                              .toStringAsFixed(1) +
                                          ")"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Adjusted Budget",
                      style: _textTheme.headline6?.copyWith(),
                    ),
                    Text(
                      "KES $_newTotal",
                      style: _textTheme.headline6?.copyWith(),
                    )
                  ],
                ),
                // TextButton(
                //   style: TextButton.styleFrom(
                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //   ),
                //   onPressed: () => showDialog<double?>(
                //     context: context,
                //     builder: (builder) => RateDialog(
                //       rate: _newTotal,
                //     ),
                //   ).then((value) {
                //     if (value != null) {
                //       setState(() {
                //         _newTotal = value;
                //       });
                //     }
                //   }),
                //   child: Text("Adjust Rate"),
                // ),
                Divider(thickness: 1.5),
                BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    if (state is ExpenseLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _expense.length,
                      itemBuilder: (_, i) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    color: HexColor(_expense[i].color),
                                  ),
                                  SizedBox(width: 3),
                                  Text(_expense[i].expense),
                                ],
                              ),
                              _expense[i].isStatic
                                  ? Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: _expense[i]
                                                  .ammount
                                                  .toString()),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      _getNewValueRate(
                                            initialExpense: _expense[i].ammount,
                                            expenseLength: _expense.length,
                                            newTotal:
                                                (_totalIncome - _totalExpense),
                                          ).toStringAsFixed(1) +
                                          "  " +
                                          " (" +
                                          _getPercentage(
                                                  _getNewValueRate(
                                                    initialExpense:
                                                        _expense[i].ammount,
                                                    expenseLength:
                                                        _expense.length,
                                                    newTotal: (_totalIncome -
                                                        _totalExpense),
                                                  ),
                                                  (_totalIncome))
                                              .toStringAsFixed(1) +
                                          "%" +
                                          ")",
                                      style: TextStyle(
                                          color: _getNewValueRate(
                                                    initialExpense:
                                                        _expense[i].ammount,
                                                    expenseLength:
                                                        _expense.length,
                                                    newTotal: (_totalIncome -
                                                        _totalExpense),
                                                  ) <
                                                  0.0
                                              ? Colors.red
                                              : Colors.black),
                                    )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Expenses that are marked "),
                      TextSpan(
                          text: "red", style: TextStyle(color: Colors.red)),
                      TextSpan(text: " cannot be budgeted for"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    if (state is ExpenseSuccess) {
                      state.expense.forEach((item) {
                        if (_getNewValueRate(
                              initialExpense: item.ammount,
                              expenseLength: _expense.length,
                              newTotal: (_totalIncome - _totalExpense),
                            ) <
                            0.0) {
                          // setState(() {
                          _loans = _loans +
                              (-1 *
                                  (_getNewValueRate(
                                    initialExpense: item.ammount,
                                    expenseLength: _expense.length,
                                    newTotal: (_totalIncome - _totalExpense),
                                  )));
                          // });

                          // print(_loans);
                        }
                      });
                    }
                    return Text("Reccomended Loan:  KES: $_loans  13% p.a");
                  },
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double _getPercentage(double value, double total) {
  return (value / total) * 100.0;
}

double _getAmmountFromPercentage(double percentage, double total) {
  return ((percentage / 100) * total);
}

double _getNewValueRate(
    {required double initialExpense,
    required double newTotal,
    required int expenseLength}) {
  return (initialExpense + (newTotal / expenseLength));
}

void handleSms(BuildContext context) {
  Telephony.instance
    ..listenIncomingSms(
      onNewMessage: (SmsMessage sms) {
        print(sms.address);
        print(sms.body);
        print(sms.subject);
        print(sms.type);
      },
      listenInBackground: false,
    )
    ..getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
      filter: SmsFilter.where(SmsColumn.ADDRESS).equals(MPESA),
      sortOrder: [
        OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC),
        OrderBy(SmsColumn.BODY)
      ],
    ).then((sms) {
      sms.forEach((element) {
        if (element.body != null && element.body!.contains(RECEIVE)) {
          // print(element.address);
          // print(element.body);

          var obj = element.body!.replaceAll(RegExp('Ksh[0-9]'), "");
          print(obj);
          // BlocProvider.of<IncomeBloc>(context).add(CreateIncomeEvent(
          //     list: [],
          //     model: IncomeModel(id: 0, income: , amount: amount),
          //     total: 0));
        }
      });
    });
}
