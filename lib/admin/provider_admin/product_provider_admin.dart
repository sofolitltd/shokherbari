import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/product_model.dart';
import '/utils/constrains.dart';

class ProductProviderAdmin {
  // addProduct
  static addProduct(
      {required ProductModel product, required String uid}) async {
    //
    await MyRepo.refProducts.doc(uid).set(product.toJson()).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Upload product successfully');
    });
  }

  // editProduct
  static editProduct(
      {required ProductModel product, required String uid}) async {
    //
    await MyRepo.refProducts.doc(uid).update(product.toJson()).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Update product successfully');
    });
  }

  //removeProduct
  static removeProduct({required String id}) {
    MyRepo.refProducts.doc(id).delete().then(
        (value) => Fluttertoast.showToast(msg: 'Delete product successfully'));
  }

  //removeProductImage
  static removeProductImage({required String imageUrl}) async {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete().then((value) {
      print('remove product images');
    });
  }
}
