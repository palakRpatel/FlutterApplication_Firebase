import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaibahuchar/Components_firebase/MyCircularImage.dart';
import 'package:jaibahuchar/firebase/MyFireStore.dart';
import 'package:jaibahuchar/model_firebase/Category.dart';
import 'package:jaibahuchar/model_firebase/Product.dart';
import 'package:jaibahuchar/model_firebase/SubCategory.dart';
import 'package:jaibahuchar/ui/AddSubCategoryDialog.dart';
import 'AppColor.dart';
import 'package:path/path.dart';

void main() {
  runApp(AddProductScreen());
}

class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Add Product",
      theme: ThemeData(primaryColor: darkBlue),
      home: MyHomePage(),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyDescriptionPage createState() => MyDescriptionPage();
}

class MyDescriptionPage extends State<MyHomePage> {
  Category dropdownCategoryValue;
  MyFireStore myFireStore;
  SubCategory dropdownSubCategoryValue;
  final txtProductName = TextEditingController();
  final txtProductDesc = TextEditingController();
  final txtPrice = TextEditingController();
  final txtSubCategory = TextEditingController();
  File _image;
  String _imageUrl;

  List<Category> categories = new List<Category>();
  List<SubCategory> subCategories = new List<SubCategory>();

  Future<void> _accessDatabase() async {
    myFireStore = MyFireStore();
    await _getCategories();
    await _getSubcategories(dropdownCategoryValue.id);
  }

  Future<void> _getSubcategories(String category_id) async {
    await myFireStore.getSubCategory(category_id).then((value) {
      setState(() {
        subCategories = value;
        dropdownSubCategoryValue = subCategories[0];
      });
    });
  }

  Future<void> _getCategories() async {
    await myFireStore.getCategories().then((value) {
      setState(() {
        categories = value;
        dropdownCategoryValue = categories[0];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _accessDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Add Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    _imgFromGallery(context);
                  },
                  child: MyCircularImage.fromImageUrl(_imageUrl, "")),
              DropdownButton<Category>(
                hint: Text("Categories"),
                value: dropdownCategoryValue,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_sharp),
                iconSize: 30,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: darkBlue,
                ),
                onChanged: (Category newValue) {
                  setState(() {
                    dropdownCategoryValue = newValue;
                    _getSubcategories(dropdownCategoryValue.id);
                  });
                },
                items: categories
                    .map<DropdownMenuItem<Category>>((Category value) {
                  return DropdownMenuItem<Category>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: DropdownButton<SubCategory>(
                        hint: Text("Sub Categories"),
                        value: dropdownSubCategoryValue,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_sharp),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: darkBlue,
                        ),
                        onChanged: (SubCategory newValue) {
                          setState(() {
                            dropdownSubCategoryValue = newValue;
                          });
                        },
                        items: subCategories.map<DropdownMenuItem<SubCategory>>(
                            (SubCategory value) {
                          return DropdownMenuItem<SubCategory>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddSubCategoryDialog(
                                    categoryId: dropdownCategoryValue.name);
                              });
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  controller: txtProductName,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your Product Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  controller: txtProductDesc,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your Product Description',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  controller: txtPrice,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Product Price',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: MaterialButton(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.lightBlue,
                  child: Text("Save"),
                  onPressed: () {
                    if (saveProduct()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Product Added"),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please add all fields")));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _imgFromGallery(BuildContext context) async {
    var pickFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 10);

    if (pickFile != null) {
      _image = File(pickFile.path);
      await myFireStore.uploadImageToFirebase(context, _image).then((value) {
        setState(() {
          _imageUrl = value;
        });
      });
    } else {
      print('No image selected.');
    }
  }

  bool saveProduct() {
    String name = txtProductName.text.toString();
    String desc = txtProductDesc.text.toString();
    String price = txtPrice.text.toString();
    Product product = new Product();
    if (!name.isEmpty && !desc.isEmpty && !price.isEmpty) {
      product.name = name;
      product.description = desc;
      product.price = price;
      product.category_id = dropdownCategoryValue.id;
      product.sub_category_id = dropdownSubCategoryValue.id;
      product.image = _imageUrl;
      myFireStore.addProduct(product);
      return true;
    } else {
      return false;
    }
  }
}
