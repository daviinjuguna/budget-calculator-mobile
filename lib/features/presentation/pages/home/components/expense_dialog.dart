import 'package:flutter/material.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/presentation/components/custom_switch.dart';

import 'input_formatters.dart';

class ExpenseDialog extends StatefulWidget {
  const ExpenseDialog({Key? key, this.expense}) : super(key: key);
  final ExpenseModel? expense;

  @override
  _CreateDialogState createState() => _CreateDialogState();
}

class _CreateDialogState extends State<ExpenseDialog> {
  late TextEditingController _title;
  late TextEditingController _desc;
  late TextEditingController _amount;
  bool _isStatic = false;
  @override
  void initState() {
    _amount = TextEditingController(text: widget.expense?.ammount.toString());
    _title = TextEditingController(text: widget.expense?.expense);
    _desc = TextEditingController(
        text: widget.expense?.percentageAmmount.toString());
    _isStatic = widget.expense?.isStatic ?? false;
    _perc = widget.expense?.percentageAmmount.toString();
    _amm = widget.expense?.ammount.toString();
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _amount.dispose();
    super.dispose();
  }

  String? _perc;
  String? _amm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.expense != null ? Text("EDIT") : Text("ADD"),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.text,
            controller: _title,
            decoration: InputDecoration(
              labelText: "Expense",
            ),
          ),
          SizedBox(
            height: 5,
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(_isStatic),
              child: _isStatic
                  ? TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [],
                      controller: _amount,
                      onChanged: (value) {
                        _amm = value;
                      },
                      decoration: InputDecoration(
                        labelText: "Amount",
                      ),
                    )
                  : TextField(
                      keyboardType: TextInputType.number,
                      controller: _desc,
                      inputFormatters: [
                        // CustomRangeTextInputFormatter(maxValue: 100.0)
                      ],
                      onChanged: (value) {
                        _perc = value;
                      },
                      decoration: InputDecoration(
                        labelText: "Percentage",
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          CustomSwitch(
              value: _isStatic,
              onChanged: (value) {
                setState(() {
                  _isStatic = value;
                  _amount.clear();
                  _desc.clear();
                });
              }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            "CANCEL",
          ),
        ),
        TextButton(
          onPressed: () {
            if (_isStatic) {
              if (_amount.text.isEmpty || _title.text.isEmpty) {
                ScaffoldMessenger.maybeOf(context)
                  ?..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.fixed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      )),
                      content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "ERROR",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // SizedBox(height: 3),
                            Text("Fill all values")
                          ])));
                return;
              }
            }
            if (!_isStatic) {
              if (_desc.text.isEmpty || _title.text.isEmpty) {
                ScaffoldMessenger.maybeOf(context)
                  ?..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.fixed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      )),
                      content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "ERROR",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // SizedBox(height: 3),
                            Text("Fill all values")
                          ])));
                return;
              }
            }
            if (widget.expense != null) {
              Navigator.of(context).pop(widget.expense?.copyWith(
                expense: _title.text.trim(),
                percentageAmmount: double.tryParse(_desc.text.trim()),
                ammount: double.tryParse(_amount.text.trim()),
                isStatic: _isStatic,
              ));
              return;
            }
            Navigator.of(context).pop(ExpenseModel(
              id: 1, //! does not matter any value
              expense: _title.text.trim(),
              percentageAmmount: double.tryParse(_desc.text.trim()),
              ammount: double.tryParse(_amount.text.trim()),
              isStatic: _isStatic,
            ));
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
