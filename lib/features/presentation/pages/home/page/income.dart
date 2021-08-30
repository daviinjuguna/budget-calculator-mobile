import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/income/income_bloc.dart';

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

  int _total = 0;

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

    late final _textTheme = Theme.of(context).textTheme;
    late final _colorScheme = Theme.of(context).colorScheme;

    return Container(
      key: ValueKey("income"),
      child: BlocConsumer<IncomeBloc, IncomeState>(
        listener: (_, state) {
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
        builder: (_, state) {
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
                    Text("Total: KES $_total"),
                    TextButton(
                      onPressed: () {
                        BlocProvider.of<IncomeBloc>(context).add(
                            CreateIncomeEvent(
                                list: _income,
                                model: IncomeModel(
                                    id: 1, income: "Funds", amount: 5000)));
                      },
                      child: Text("Add Icome"),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () {
                  BlocProvider.of<IncomeBloc>(context)
                      .add(RefreshIncomeEvent());
                  return _completer.future;
                },
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _income.length,
                  itemBuilder: (_, i) => Card(
                    child: ListTile(
                      title: Text(_income[i].income),
                      subtitle: Text("KES ${_income[i].amount.truncate()}"),
                    ),
                  ),
                ),
              ))
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
