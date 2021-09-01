import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/core/utils/hex_converter.dart';

import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/expense/expense_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/income/income_bloc.dart';

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
    });
  }

  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  List<ExpenseModel> _expense = [];
  List<NewModel> _new = [];
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
            _new.clear();
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
                              // _expense[i].isStatic
                              //     ? TextSpan(
                              //         text: "\t(fixed)",
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.w200,
                              //           color: Colors.grey,
                              //         ),
                              //       )
                              //     : TextSpan(
                              //         text: "\t(adjustable)",
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.w200,
                              //           color: Colors.grey,
                              //         ),
                              //       ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double _getAmmountFromPercentage(double percentage, double total) {
  return ((percentage / 100) * total);
}

class NewModel {
  final String name;
  final Color color;
  final double ammount;
  NewModel({
    required this.name,
    required this.color,
    required this.ammount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NewModel &&
        other.name == name &&
        other.color == color &&
        other.ammount == ammount;
  }

  @override
  int get hashCode => name.hashCode ^ color.hashCode ^ ammount.hashCode;

  @override
  String toString() =>
      'NewModel(name: $name, color: $color, ammount: $ammount)';

  NewModel copyWith({
    String? name,
    Color? color,
    double? ammount,
  }) {
    return NewModel(
      name: name ?? this.name,
      color: color ?? this.color,
      ammount: ammount ?? this.ammount,
    );
  }
}
