import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmationDialog extends StatelessWidget {
  String title;
  String message;
  VoidCallback onYes;

  ConfirmationDialog(
      {Key? key,
      required this.title,
      required this.message,
      required this.onYes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text("Yes"),
          onPressed: () {
            onYes();
            Navigator.of(context).pop();
            // return false;
          },
        ),
        TextButton(
          child: Text("No"),
          onPressed: () {
            // return true;
            Navigator.pop(context);

            // exit(0);
            // SystemNavigator.ex();
          },
        ),
      ],
    );
  }
}
