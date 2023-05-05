import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageHelper {
  static getImage(String imageUrl) {
    if (imageUrl != null && !imageUrl.contains('no_pic')) {
      return CachedNetworkImage(
          width: 90,
          height: 90,
          imageUrl: imageUrl,
          placeholder: (context, url) =>
              Image.memory(kTransparentImage, width: 100, height: 100),
          errorWidget: (context, url, error) => _emptyImage());
    } else {
      return _emptyImage();
    }
  }

  static _emptyImage() {
    return Container(
        color: Colors.white,
        width: 90,
        height: 90,
        child: Icon(Icons.cloud_off));
  }
}
