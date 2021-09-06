import 'package:flutter/material.dart';

import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';

class ExpenseDialog extends StatefulWidget {
  const ExpenseDialog({Key? key, this.expense}) : super(key: key);
  final ExpenseModel? expense;

  @override
  _CreateDialogState createState() => _CreateDialogState();
}

class _CreateDialogState extends State<ExpenseDialog> {
  late final List<ExpenseType> _type = [
    ExpenseType(name: "Static", isStatic: true),
    ExpenseType(name: "Dynamic", isStatic: false)
  ];

  late TextEditingController _title;
  late TextEditingController _amount;
  late ExpenseType _expenseType;
  // late final
  @override
  void initState() {
    _amount = TextEditingController(text: widget.expense?.ammount.toString());
    _title = TextEditingController(text: widget.expense?.expense);
    if (widget.expense != null) {
      _expenseType = _type.singleWhere(
          (element) => element.isStatic == widget.expense!.isStatic);
      return;
    } else {
      _expenseType = _type.singleWhere((element) => !element.isStatic);
    }
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
          DropdownButtonFormField<ExpenseType>(
            decoration: InputDecoration(labelText: "Choose type"),
            value: _expenseType,
            onChanged: (value) {
              setState(() {
                _expenseType = value!;
              });
            },
            items: _type
                .map((e) => DropdownMenuItem<ExpenseType>(
                    child: Text(e.name), value: e))
                .toList(),
          )
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
            if (_expenseType.isStatic) {
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
                isStatic: _expenseType.isStatic,
              ));
              return;
            }
            Navigator.of(context).pop(ExpenseModel(
              id: 1, //! does not matter any value
              expense: _title.text.trim(),
              recommended: 0,
              ammount: double.tryParse(_amount.text.trim())!,
              isStatic: _expenseType.isStatic,
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

class ExpenseType {
  final String name;
  final bool isStatic;
  ExpenseType({
    required this.name,
    required this.isStatic,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseType &&
        other.name == name &&
        other.isStatic == isStatic;
  }

  @override
  int get hashCode => name.hashCode ^ isStatic.hashCode;

  @override
  String toString() => 'ExpenseType(name: $name, isStatic: $isStatic)';
}
