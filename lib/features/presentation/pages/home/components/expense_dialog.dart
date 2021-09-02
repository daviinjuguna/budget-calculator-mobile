import 'package:flutter/material.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/presentation/components/custom_switch.dart';

import 'dart:math' as math;

class ExpenseDialog extends StatefulWidget {
  const ExpenseDialog({Key? key, this.expense}) : super(key: key);
  final ExpenseModel? expense;

  @override
  _CreateDialogState createState() => _CreateDialogState();
}

class _CreateDialogState extends State<ExpenseDialog> {
  late TextEditingController _title;
  late TextEditingController _amount;
  bool _isStatic = false;
  @override
  void initState() {
    _amount = TextEditingController(text: widget.expense?.ammount.toString());
    _title = TextEditingController(text: widget.expense?.expense);
    _isStatic = widget.expense?.isStatic ?? false;
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.expense != null ? Text("EDIT") : Text("ADD"),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TextField(
          //   keyboardType: TextInputType.text,
          //   controller: _title,
          //   decoration: InputDecoration(
          //     labelText: "Expense",
          //   ),
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [],
            controller: _amount,
            decoration: InputDecoration(
              labelText: "Amount",
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
            if (widget.expense != null) {
              Navigator.of(context).pop(widget.expense?.copyWith(
                expense: _title.text.trim(),
                ammount: double.tryParse(_amount.text.trim()),
                isStatic: _isStatic,
              ));
              return;
            }
            Navigator.of(context).pop(ExpenseModel(
              id: 1, //! does not matter any value
              expense: _title.text.trim(),
              ammount: double.tryParse(_amount.text.trim())!,
              color: "#" +
                  (Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                          .withOpacity(1.0)
                          .value
                          .toRadixString(16)
                          .toUpperCase())
                      .lastChars(6),
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
