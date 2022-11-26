import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './adaptive_flatButton.dart';

class NewTransaction extends StatefulWidget {
  final Function addTrx;
  NewTransaction(this.addTrx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final inputTitle = TextEditingController();
  late DateTime date;
  @override
  void initState() {
    date = DateTime(1999);
    super.initState();
  }

  final inputAmount = TextEditingController();

  void _addTransaction() {
    if (inputAmount.text.isEmpty) {
      return;
    }
    final text = inputTitle.text;
    final price = double.parse(
      (inputAmount.text),
    );
    if (text.isEmpty || price <= 0 || date == null) return;
    widget.addTrx(
      text,
      price,
      date,
    );
    Navigator.of(context).pop();
  }

  void _chooseDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        date = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: inputTitle,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: inputAmount,
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  _addTransaction();
                },
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              Row(
                children: <Widget>[
                  Text(date.year == 1999
                      ? 'No Date Choosen!'
                      : DateFormat.yMEd().format(date)),
                  adaptiveFlatButton(_chooseDate),
                ],
              ),
              RaisedButton(
                onPressed: _addTransaction,
                textColor: Theme.of(context).primaryColor,
                child: Text('Add Transaction'),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
