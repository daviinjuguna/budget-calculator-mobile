import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/core/utils/constants.dart';
import 'package:sortika_budget_calculator/core/utils/hex_converter.dart';
import 'package:sortika_budget_calculator/core/utils/themes.dart';

import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/expense/expense_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/income/income_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/components/create_dialog.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/components/expense_dialog.dart';
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
      BlocProvider.of<ExpenseBloc>(context).add(GetExpenseEvent());
      // handleSms(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  List<ExpenseModel> _expense = [];
  List<IncomeModel> _income = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    late final _textTheme = Theme.of(context).textTheme;
    final _cardWidth = ((MediaQuery.of(context).size.width) - 46.0) / 2;
    return MultiBlocListener(
      key: ValueKey("budget"),
      listeners: [
        BlocListener<ExpenseBloc, ExpenseState>(
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
        ),
        BlocListener<IncomeBloc, IncomeState>(
          listener: (context, state) {
            if (state is IncomeSuccess) {
              _income = state.income;
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: RefreshIndicator(
          onRefresh: () {
            BlocProvider.of<IncomeBloc>(context).add(RefreshIncomeEvent());
            BlocProvider.of<ExpenseBloc>(context).add(RefreshExpenseEvent());
            return _completer.future;
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        child: Container(
                          height: _cardWidth,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: kCardGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Total Income",
                                style: TextStyle(
                                  color: kPurpleColor,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              BlocBuilder<IncomeBloc, IncomeState>(
                                builder: (context, state) {
                                  String _total = "0.0";
                                  if (state is IncomeLoading) {
                                    _total = "Loading";
                                  }
                                  if (state is IncomeSuccess) {
                                    _total =
                                        "KES " + state.total.toStringAsFixed(1);
                                  }
                                  return Text(
                                    _total,
                                    style: TextStyle(
                                      color: kPurpleColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        child: Container(
                          height: _cardWidth,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Total Expense",
                                style: TextStyle(
                                  color: kPurpleColor,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              BlocBuilder<ExpenseBloc, ExpenseState>(
                                builder: (context, state) {
                                  String _total = "0.0";
                                  if (state is ExpenseLoading) {
                                    _total = "Loading";
                                  }
                                  if (state is ExpenseSuccess) {
                                    _total =
                                        "KES " + state.total.toStringAsFixed(1);
                                  }
                                  return Text(
                                    _total,
                                    style: TextStyle(
                                      color: kPurpleColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            gradient: kCardGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Budget Calculator",
                  style: _textTheme.headline6?.copyWith(),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 80,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Monthly Budget"),
                      Text(
                        "KES 100000",
                        style: _textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    gradient: kCardGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Enter income streams to calculate your budget",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 20),
                BlocBuilder<IncomeBloc, IncomeState>(
                  builder: (context, state) {
                    double _total = 0.0;
                    if (state is IncomeSuccess) {
                      _total = state.total;
                    }
                    return Container(
                      height: 100,
                      child: ListView.separated(
                        separatorBuilder: (_, __) => SizedBox(width: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: _income.length + 1,
                        itemBuilder: (_, i) {
                          if (i == _income.length)
                            return GestureDetector(
                              onTap: () => showDialog<IncomeModel?>(
                                      context: context,
                                      builder: (builder) => CreateDialog())
                                  .then((value) {
                                if (value != null) {
                                  BlocProvider.of<IncomeBloc>(context).add(
                                      CreateIncomeEvent(
                                          list: _income,
                                          model: value,
                                          total: _total));
                                }
                              }),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add,
                                        color: kPurpleColor,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Add new income",
                                      style: TextStyle(
                                          color: kPurpleColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  gradient: kCardGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: kPurpleColor,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _income[i].income,
                                      style: TextStyle(
                                          color: kPurpleColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10),
                                    Text("KES ${_income[i].amount}")
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () => showDialog<IncomeModel?>(
                                          context: context,
                                          builder: (builder) => CreateDialog(
                                            income: _income[i],
                                          ),
                                        ).then((value) {
                                          if (value != null) {
                                            BlocProvider.of<IncomeBloc>(context)
                                                .add(EditIncomeEvent(
                                              list: _income,
                                              model: value,
                                              initial: _income[i],
                                              index: i,
                                              total: _total,
                                            ));
                                          }
                                        }),
                                    icon: Icon(Icons.edit))
                              ],
                            ),
                            decoration: BoxDecoration(
                              gradient: kCardGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Based on your budget, this is what we recommend",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 20),
                BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    double _total = 0.0;
                    if (state is ExpenseSuccess) {
                      _total = state.total;
                    }
                    return Container(
                      height: 100,
                      child: ListView.separated(
                        separatorBuilder: (_, __) => SizedBox(width: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: _expense.length + 1,
                        itemBuilder: (_, i) {
                          if (i == _expense.length)
                            return GestureDetector(
                              onTap: () => showDialog<ExpenseModel?>(
                                      context: context,
                                      builder: (builder) => ExpenseDialog())
                                  .then((value) {
                                if (value != null) {
                                  BlocProvider.of<ExpenseBloc>(context).add(
                                      CreateExpenseEvent(
                                          list: _expense,
                                          model: value,
                                          total: _total));
                                }
                              }),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add,
                                        color: kPurpleColor,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Add new Expense",
                                      style: TextStyle(
                                          color: kGreen,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  gradient: kGreenGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: kGreen,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _expense[i].expense,
                                      style: TextStyle(
                                          color: kGreen,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10),
                                    Text("KES ${_expense[i].ammount}")
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () => showDialog<ExpenseModel?>(
                                          context: context,
                                          builder: (builder) => ExpenseDialog(
                                            expense: _expense[i],
                                          ),
                                        ).then((value) {
                                          if (value != null) {
                                            BlocProvider.of<ExpenseBloc>(
                                                    context)
                                                .add(EditExpenseEvent(
                                              list: _expense,
                                              model: value,
                                              initial: _expense[i],
                                              index: i,
                                              total: _total,
                                            ));
                                          }
                                        }),
                                    icon: Icon(Icons.edit))
                              ],
                            ),
                            decoration: BoxDecoration(
                              gradient: kGreenGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double _getPercentage(double value, double total) => (value / total) * 100.0;

double _getAmmountFromPercentage(double percentage, double total) =>
    ((percentage / 100) * total);

double _getNewValueRate(
    {required double initialExpense,
    required double newTotal,
    required int expenseLength}) {
  return (initialExpense + (newTotal / expenseLength));
}

double _getRecommendedLoans({
  required double adjPerce,
  required double loanIntrest,
  required double income,
}) =>
    ((adjPerce - (loanIntrest / 12)) * income);

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
