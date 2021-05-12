import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jaibahuchar/model_firebase/Product.dart';
import 'package:jaibahuchar/model_firebase/Category.dart';
import 'package:jaibahuchar/model_firebase/SubCategory.dart';
import 'package:path/path.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class MyFireStore {
  MyFireStore() {
    Firebase.initializeApp();
  }

  Future<String> uploadImageToFirebase(
      BuildContext context, File imageFile) async {
    String imageUrl = "";
    String fileName = basename(imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    await uploadTask.whenComplete(() async {
      await firebaseStorageRef.getDownloadURL().then((value) async {
        imageUrl = value;
      });
    });
    return imageUrl;
  }

  Future<String> getImageURL(String url) async {
    final ref = FirebaseStorage.instance.ref().child('upload');
    return await ref.getDownloadURL();
  }

  Future<List<Category>> getCategories() async {
    List<Category> categoriesList = new List<Category>();
    await FirebaseFirestore.instance.collection('Category').get().then((value) {
      value.docs.forEach((element) async {
        await categoriesList
            .add(new Category(id: element.id, name: element.id));
      });
    });
    return categoriesList;
  }

  Future<List<SubCategory>> getSubCategory(String categoryId) async {
    List<SubCategory> subCategoriesList = new List<SubCategory>();

    await FirebaseFirestore.instance
        .collection("SubCategory")
        .where('category_id', isEqualTo: categoryId)
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        await subCategoriesList
            .add(new SubCategory(id: element.id, name: element.get("name")));
      });
    });
    return subCategoriesList;
  }

  Future<List<Product>> getProduct(
      String categoryId, String subCategoryId) async {
    List<Product> productList = new List<Product>();

    await FirebaseFirestore.instance
        .collection("Product")
        .where('category_id', isEqualTo: categoryId)
        .get()
        .then((value) async {
      await value.docs.forEach((element) {
        productList.add(new Product.fromJson(element.id, element.data()));
      });
    });
    return productList;
  }

  Future<void> addSubCategory(SubCategory subCategory) async {
    await FirebaseFirestore.instance
        .collection("SubCategory")
        .add(subCategory.toJson())
        .then((value) async {
      value.get().then((value) {});
    });
  }

  Future<void> addProduct(Product product) async {
    await FirebaseFirestore.instance
        .collection("Product")
        .add(product.toJson())
        .then((value) async {
      value.get().then((value) {});
    });
  }

  Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection("Product")
        .doc(productId)
        .delete();
  }
}
