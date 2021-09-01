import 'dart:async';

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

    late final _textTheme = Theme.of(context).textTheme;
    late final _colorScheme = Theme.of(context).colorScheme;

    return Container(
      key: ValueKey("income"),
      child: BlocConsumer<IncomeBloc, IncomeState>(
        listener: (_, state) {
          if (state is IncomeSuccess) {
            _total = state.total;
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
                      onPressed: () => showDialog<IncomeModel?>(
                        context: context,
                        builder: (builder) => CreateDialog(),
                      ).then((value) {
                        if (value != null) {
                          BlocProvider.of<IncomeBloc>(context).add(
                              CreateIncomeEvent(
                                  total: _total, list: _income, model: value));
                        }
                      }),
                      child: Text("Add Icome"),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: (state is IncomeLoading)
                      ? Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
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
                                subtitle: Text("KES ${_income[i].amount}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                                  initial: _income[i],
                                                  model: value,
                                                  index: i,
                                                  total: _total));
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
                                                  Navigator.of(context)
                                                      .pop(null),
                                              child: Text(
                                                "CANCEL",
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text(
                                                "DELETE",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).then((value) {
                                        if (value != null && value) {
                                          BlocProvider.of<IncomeBloc>(context)
                                              .add(DeleteIncomeEvent(
                                                  list: _income,
                                                  model: _income[i],
                                                  total: _total));
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
