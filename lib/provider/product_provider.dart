import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  // ref products
  List<ProductModel> _productList = [];

  // fetchProduct
  fetchProducts() async {
    List<ProductModel> _newList = [];
    //
    // print(_productList);
    QuerySnapshot values =
        await FirebaseFirestore.instance.collection('Product').get();

    for (var value in values.docs) {
      ProductModel productModel = ProductModel(
        category: value.get('category'),
        subcategory: value.get('subcategory'),
        id: value.get('id'),
        name: value.get('name'),
        description: value.get('description'),
        regularPrice: value.get('regular_price'),
        salePrice: value.get('sale_price'),
        stockQuantity: value.get('stockQuantity'),
        featured: value.get('featured'),
        images: value.get('images'),
        weight: '',
        searchKey: value.get('searchKey'),
      );
      _newList.add(productModel);
      _productList = _newList;
    }
    notifyListeners();
  }

  List<ProductModel> get getProductDataList => _productList;
}
