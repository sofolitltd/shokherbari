import 'package:fluttertoast/fluttertoast.dart';

import '../models/product_model.dart';
import '../utils/constrains.dart';

class WishlistProvider {
  //addToWishList
  static addToWishList({required ProductModel product}) async {
    await MyRepo.refWishlist
        .doc(product.id)
        .set({'product_id': product.id}).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Add to wishList');
    });
  }

  //removeFromWishList
  static removeFromWishList({required String id}) async {
    await MyRepo.refWishlist.doc(id).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from wishList');
    });
  }
}
