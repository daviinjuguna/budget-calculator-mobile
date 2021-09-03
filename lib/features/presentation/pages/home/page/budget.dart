import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/core/utils/constants.dart';
import 'package:sortika_budget_calculator/core/utils/hex_converter.dart';
import 'package:sortika_budget_calculator/core/utils/themes.dart';

import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    late final _textTheme = Theme.of(context).textTheme;
    final _cardWidth = ((MediaQuery.of(context).size.width) - 19.0) / 2;
    return MultiBlocListener(
      key: ValueKey("budget"),
      listeners: [
        BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {},
        ),
        BlocListener<IncomeBloc, IncomeState>(
          listener: (context, state) {},
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
                          child: Text(
                            "KES 100000",
                            style: TextStyle(
                              color: kPurpleColor,
                              fontWeight: FontWeight.bold,
                            ),
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
                          child: Text(
                            "KES 100000",
                            style: TextStyle(
                              color: kPurpleColor,
                              fontWeight: FontWeight.bold,
                            ),
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
