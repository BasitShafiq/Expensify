import 'package:expense_calculator/widgets/Chart_Bars.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Charts extends StatelessWidget {
  final List<Transaction> recentTransaction;
  const Charts(this.recentTransaction);

  List<Map<String, Object>> get TransactionValueForChart {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var amountSpentPerDay = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year) {
          amountSpentPerDay += recentTransaction[i].amount;
        }
      }
      return {
        'date': DateFormat.E().format(weekDay),
        'amount': amountSpentPerDay,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return TransactionValueForChart.fold(
      0,
      (sum, element) {
        return sum + (element['amount'] as double);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(TransactionValueForChart);
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: TransactionValueForChart.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBars(
                  data['date'] as String,
                  data['amount'] as double,
                  totalSpending == 0
                      ? 0.0
                      : ((data['amount'] as double) / totalSpending),
                ),
              );
            }).toList()),
      ),
    );
  }
}
