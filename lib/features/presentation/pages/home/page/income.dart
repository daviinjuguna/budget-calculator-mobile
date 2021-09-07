import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/income/income_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/pages/home/components/create_dialog.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({Key? key}) : super(key: key);

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      BlocProvider.of<IncomeBloc>(context).add(GetIncomeEvent());
    });
    super.initState();
  }

  double _total = 0;

  List<IncomeModel> _income = [];
  late Completer<void> _completer = Completer();
  // late bool _loadFirs = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocListener(
      key: ValueKey("income"),
      listeners: [
        BlocListener<IncomeBloc, IncomeState>(
          listener: (context, state) {
            if (state is IncomeInitial) {
              ScaffoldMessenger.maybeOf(context)?..hideCurrentSnackBar();
            }
            if (state is IncomeSuccess) {
              ScaffoldMessenger.maybeOf(context)?..hideCurrentSnackBar();
              _total = state.total;
              _income = state.income;

              _completer.complete();
              _completer = Completer();
            }
            if (state is IncomeUpdting) {
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
            if (state is IncomeError) {
              ScaffoldMessenger.maybeOf(context)?..hideCurrentSnackBar();
              _completer.complete();
              _completer = Completer();
            }
          },
        )
      ],
      child: RefreshIndicator(
        onRefresh: () {
          BlocProvider.of<IncomeBloc>(context).add(RefreshIncomeEvent());
          return _completer.future;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 30),
              Container(
                alignment: Alignment.topCenter,
                height: 200,
                child: BlocBuilder<IncomeBloc, IncomeState>(
                  builder: (context, state) {
                    if (state is IncomeLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return PieChart(
                      PieChartData(
                        sections: _income
                            .map(
                              (income) => PieChartSectionData(
                                value: _getPercentage(income.amount, _total),
                                showTitle: true,
                                title: income.income +
                                    "\n" +
                                    "${_getPercentage(income.amount, _total).toStringAsFixed(1)}%",
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tansactions"),
                  IconButton(
                    onPressed: () => showDialog<IncomeModel?>(
                        context: context,
                        builder: (builder) => CreateDialog()).then((value) {
                      if (value != null) {
                        BlocProvider.of<IncomeBloc>(context).add(
                            CreateIncomeEvent(
                                list: _income, model: value, total: _total));
                      }
                    }),
                    icon: Icon(Icons.add),
                    color: Colors.black,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

double _getPercentage(double value, double total) => (value / total) * 100.0;
