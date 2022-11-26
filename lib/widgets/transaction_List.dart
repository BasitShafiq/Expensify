import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transactionItem.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function _deleteTransaaction;
  TransactionList(this.transaction, this._deleteTransaaction);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      child: transaction.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Text(
                      'No Transactions yet! Add one',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.4,
                      child: Image.asset('assets/images/waiting.png'),
                    ),
                  ],
                );
              },
            )
          : ListView(
              children: transaction
                  .map((tx) => TransactionItem(
                        key: ValueKey(tx.id),
                        transaction: tx,
                        deleteTransaaction: _deleteTransaaction,
                      ))
                  .toList()),
    );
  }
}
