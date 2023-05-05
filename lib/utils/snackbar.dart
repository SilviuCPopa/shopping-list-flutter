
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Snackbar {

  static showSnackbar(BuildContext context, String title) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(title, textAlign: TextAlign.center),
        )
      ); 
  }
}