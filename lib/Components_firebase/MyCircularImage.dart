import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaibahuchar/ui/AppColor.dart';

class MyCircularImage extends StatelessWidget {
  Uint8List image;
  String imageUrl;

  MyCircularImage({Key key, this.title, this.image}) : super(key: key);

  MyCircularImage.fromImageUrl(this.imageUrl, this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return CircleAvatar(
      radius: 25,
      child: image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.memory(
                image,
                width: 50.0,
                height: 50.00,
                fit: BoxFit.fitWidth,
              ),
            )
          : imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    imageUrl,
                    width: 50.0,
                    height: 50.00,
                    fit: BoxFit.fitWidth,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25)),
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
    );
  }
}
