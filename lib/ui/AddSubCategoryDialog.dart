import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaibahuchar/firebase/MyFireStore.dart';
import 'package:jaibahuchar/model_firebase/Category.dart';
import 'package:jaibahuchar/model_firebase/Product.dart';
import 'package:jaibahuchar/model_firebase/SubCategory.dart';
import 'AppColor.dart';
import 'package:path/path.dart';

class AddSubCategoryDialog extends StatefulWidget {
  String categoryId;

  AddSubCategoryDialog({this.categoryId, this.title});

  final String title;

  @override
  MyDescriptionPage createState() => MyDescriptionPage();
}

class MyDescriptionPage extends State<AddSubCategoryDialog> {
  MyFireStore myFireStore;

  List<Category> categories = new List<Category>();
  List<SubCategory> subCategories = new List<SubCategory>();
  final txtSubCategory = TextEditingController();

  Future<void> _accessDatabase() async {
    myFireStore = MyFireStore();
  }

  @override
  void initState() {
    // TODO: implement initState
    _accessDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text('Add SubCategory'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: txtSubCategory,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Sub Category Name',
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Add'),
            onPressed: () {
              String name = txtSubCategory.text.toString();
              SubCategory subCat = new SubCategory();
              if (!name.isEmpty) {
                subCat.category_id = widget.categoryId;
                subCat.name = name;
                myFireStore.addSubCategory(subCat);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Subcategory Added"),
                ));
                Navigator.of(context).pop();
              }
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
