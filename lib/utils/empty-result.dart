import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EmptyResults extends StatefulWidget {
  String title;

  EmptyResults({this.title});

  @override
  _EmptyResultsState createState() => _EmptyResultsState();
}

class _EmptyResultsState extends State<EmptyResults> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SafeArea(
            child: Center(
                child: Container(
                    height: 150,
                    width: 350,
                    child: Column(
                      children: [
                        Icon(Icons.apps, size: 40.0),
                        Divider(color: Colors.transparent),
                        Text(widget.title ?? 'No results!',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 18.0)),
                      ],
                    )))),
      ],
    );
  }
}
