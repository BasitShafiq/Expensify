import 'dart:io';
import 'package:flutter/cupertino.dart';
import '/widgets/new_Transaction.dart';
import '/widgets/transaction_List.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import './widgets/charts.dart';

void main() {
  //stoping the device in one rotation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Calculator',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 137, 61, 172),
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
              ),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //initiating the listner
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final List<Transaction> transaction = [];
  void _addTransaction(String title, double amount, DateTime selectedDate) {
    final newTx = Transaction(
        title: title,
        amount: amount,
        id: DateTime.now().toString(),
        date: selectedDate);
    setState(() {
      transaction.add(newTx);
    });
  }

  void _deleteTransaaction(String id) {
    setState(() {
      transaction.removeWhere((element) => element.id == id);
    });
  }

  List<Transaction> get _recentTransaction {
    return transaction
        .where(
          (element) => element.date.isAfter(
            DateTime.now().subtract(
              Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  void _startTransactionModel(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: NewTransaction(_addTransaction),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar app_Bar,
    Widget trxList,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch.adaptive(
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              width: double.infinity,
              height: (mediaQuery.size.height -
                      app_Bar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: Charts(_recentTransaction),
            )
          : trxList,
    ];
  }

  List<Widget> _buildPotraitContent(
    MediaQueryData mediaQuery,
    AppBar app_Bar,
    Widget trxList,
  ) {
    return [
      Container(
        width: double.infinity,
        height: (mediaQuery.size.height -
                app_Bar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Charts(_recentTransaction),
      ),
      trxList
    ];
  }

  bool _showChart = true;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final mediaQuery = MediaQuery.of(context);

    final dynamic app_Bar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Expense Calculator',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _startTransactionModel(context);
                  },
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Expense Calculator',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          );

    final trxList = Container(
      height: (mediaQuery.size.height -
              app_Bar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(transaction, _deleteTransaaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (!isLandscape)
              ..._buildPotraitContent(
                mediaQuery,
                app_Bar,
                trxList,
              ),
            if (isLandscape)
              ..._buildLandscapeContent(
                mediaQuery,
                app_Bar,
                trxList,
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: app_Bar,
          )
        : Scaffold(
            appBar: app_Bar,
            body: pageBody,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _startTransactionModel(context);
              },
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
