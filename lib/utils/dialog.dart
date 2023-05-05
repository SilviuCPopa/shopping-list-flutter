import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DialogActions { cancel, confirm }

class CustomDialog {
  String title = '';
  String subtitle = '';
  TextEditingController controller;
  int quantity = 1;

  CustomDialog(this.title, {this.subtitle, this.controller});

  Future<void> showGeneralDialog(
      BuildContext context, Widget childrens,
      {bool showActions = true, Function callback}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            actionsOverflowButtonSpacing: 20.0,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(title, style: TextStyle(fontSize: 17))]),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[childrens],
              ),
            ),
            actions: showActions ? _defaultActions(context, callback) : []);
      },
    );
  }

  Future<void> showAddItemDialog(
      BuildContext context, Function callback) {
    return this.showGeneralDialog(
        context,
        TextFormField(
          controller: controller,
          decoration: new InputDecoration(hintText: AppLocalizations.of(context).enterName),
        ),
        callback: callback);
  }

  Future<void> showConfirmDialog(
      BuildContext context, Function callback) {
    return this.showGeneralDialog(context, Text(subtitle), callback: callback);
  }

  _defaultActions(BuildContext context, Function callback) {
    return <Widget>[
      TextButton(
          style: TextButton.styleFrom(primary: Theme.of(context).textTheme.bodyText1.color),
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
            callback(DialogActions.cancel);
          }),
      TextButton(
        style: TextButton.styleFrom(primary: Colors.red),
        child: Text(AppLocalizations.of(context).confirm),
        onPressed: () {
          Navigator.of(context).pop();
          callback(DialogActions.confirm);
        },
      ),
    ];
  }
}
