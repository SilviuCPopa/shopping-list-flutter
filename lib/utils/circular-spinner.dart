import 'package:flutter/material.dart';

class CircularSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SafeArea(
            child: Center(
                child: Container(
                    height: 120,
                    width: 120,
                    child: CircularProgressIndicator()))),
      ],
    );
  }
}
