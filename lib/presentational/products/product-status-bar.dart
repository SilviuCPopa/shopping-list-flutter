import 'package:flutter/material.dart';

class ProductStatusBarWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    
    return BottomAppBar(
      child: Container(
        child: Container(height: 5)
      ),
      color: !darkModeOn ? Colors.white : Colors.transparent,
    );
  }
}
