import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/models/cart_list.dart';

import '../models/product_model.dart';
import '../utils/constrains.dart';

class CartProvider {
  // addToCart
  static addToCart({required ProductModel product}) async {
    CartList cartProduct =
        CartList(productId: product.id, quantity: 1, price: product.salePrice);
    await MyRepo.refCart
        .doc(product.id)
        .set(cartProduct.toJson())
        .then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Add to cart');
    });
  }

  // removeFromCart
  static removeFromCart(
      {required String id, bool? disableToast = false}) async {
    await MyRepo.refCart.doc(id).delete().then((value) {
      if (disableToast == false) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Remove from cart');
      }
    });
  }

  //addQuantity
  static addQuantity({required String id, required int quantity}) async {
    await MyRepo.refCart
        .doc(id)
        .update({'quantity': quantity + 1}).then((value) {});
  }

  //removeQuantity
  static removeQuantity({required String id, required int quantity}) async {
    if (quantity != 1) {
      await MyRepo.refCart
          .doc(id)
          .update({'quantity': quantity - 1}).then((value) {});
    }
  }
}
