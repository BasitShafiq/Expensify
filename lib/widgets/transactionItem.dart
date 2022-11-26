import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    required Key? key,
    required this.transaction,
    required this.deleteTransaaction,
  }) : super(key: key);

  final transaction;
  final Function deleteTransaaction;
  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Color _bgColor;
  @override
  void initState() {
    print('Color Changing');
    const List colorList = [
      Colors.blue,
      Colors.red,
      Colors.black,
      Colors.purple,
    ];
    _bgColor = colorList[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      elevation: 5,
      child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: FittedBox(
                  child: Text(
                '${widget.transaction.amount}',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
            ),
            backgroundColor: _bgColor,
            // backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(
            widget.transaction.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            DateFormat.yMMMEd().format(widget.transaction.date),
            style: TextStyle(color: Colors.grey),
          ),
          trailing: MediaQuery.of(context).size.width <= 400
              ? IconButton(
                  onPressed: () {
                    widget.deleteTransaaction(widget.transaction.id);
                  },
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                )
              : FlatButton.icon(
                  onPressed: () {
                    widget.deleteTransaaction(widget.transaction.id);
                  },
                  label: const Text('delete'),
                  textColor: Theme.of(context).errorColor,
                  icon: Icon(Icons.delete),
                )),
    );
  }
}
