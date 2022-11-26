import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class adaptiveFlatButton extends StatelessWidget {
  final VoidCallback _chooseDate;
  adaptiveFlatButton(this._chooseDate);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: _chooseDate,
            child: Text(
              'Choose Date',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            color: Colors.white,
          )
        : FlatButton(
            onPressed: _chooseDate,
            child: Text(
              'Choose Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            textColor: Theme.of(context).primaryColor,
          );
  }
}
