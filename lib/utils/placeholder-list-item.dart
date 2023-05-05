import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaceholderListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500.0,
      height: 100.0,
      child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 260,
                    height: 10,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 10,
                    width: 270,
                  ),
                  Container(
                    width: 150,
                    height: 10,
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
