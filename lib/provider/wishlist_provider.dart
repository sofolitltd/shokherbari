import 'package:fluttertoast/fluttertoast.dart';

import '../models/product_model.dart';
import '../utils/constrains.dart';

class WishlistProvider {
  //addToWishList
  static addToWishList({required ProductModel product}) async {
    await UserRepo.refWishlist
        .doc(product.id)
        .set({'productId': product.id}).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Add to wishList');
    });
  }

  //removeFromWishList
  static removeFromWishList({required String id}) async {
    await UserRepo.refWishlist.doc(id).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from wishList');
    });
  }
}
