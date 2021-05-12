import 'dart:ui';

import 'package:jaibahuchar/firebase/MyFireStore.dart';
import 'package:jaibahuchar/model_firebase/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'AppColor.dart';

class DetailScreen_firebase extends StatelessWidget {
  Product product;

  DetailScreen_firebase(this.product);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Description",
      theme: ThemeData(primaryColor: lightPink),
      home: MyHomePage(product),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MyHomePage extends StatefulWidget {
  Product product;

  MyHomePage(this.product, {Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyDescriptionPage createState() => MyDescriptionPage();
}

class MyDescriptionPage extends State<MyHomePage> {
  MyFireStore fireStore;

  @override
  void initState() {
    // TODO: implement initState
    fireStore = MyFireStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            leadingWidth: double.infinity,
            pinned: true,
            snap: false,
            floating: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              tooltip: 'Menu',
              onPressed: () {},
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.product.name),
              background: widget.product.image != null
                  ? Image.network(widget.product.image)
                  : Image.asset('assets/images/viewpager1.png'),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Text(widget.product.description,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center),
              Text("Price: " + widget.product.price.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center),
              Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: MaterialButton(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.lightBlue,
                      child: Text("Delete Product"),
                      onPressed: () {
                        fireStore.deleteProduct(widget.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Product Deleted"),
                        ));
                      })),
            ]),
          ),
        ],
      ),
    );
  }
}
