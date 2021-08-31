import 'package:flutter/material.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';

class CreateDialog extends StatefulWidget {
  const CreateDialog({Key? key, this.income}) : super(key: key);
  final IncomeModel? income;

  @override
  _CreateDialogState createState() => _CreateDialogState();
}

class _CreateDialogState extends State<CreateDialog> {
  late TextEditingController _title;
  late TextEditingController _desc;
  @override
  void initState() {
    _title = TextEditingController(text: widget.income?.income);
    _desc = TextEditingController(text: widget.income?.amount.toString());
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.income != null ? Text("EDIT") : Text("ADD"),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.text,
            controller: _title,
            decoration: InputDecoration(
              labelText: "Income",
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _desc,
            decoration: InputDecoration(
              labelText: "Ammount",
            ),
          ),
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
            if (widget.income != null) {
              Navigator.of(context).pop(widget.income?.copyWith(
                income: _title.text.trim(),
                amount: double.parse(_desc.text.trim()),
              ));
              return;
            }
            Navigator.of(context).pop(IncomeModel(
              id: 1, //! does not matter any value
              income: _title.text.trim(),
              amount: double.parse(_desc.text.trim()),
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
