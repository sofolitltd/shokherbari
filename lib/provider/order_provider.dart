import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/models/order_model.dart';
import 'package:shokher_bari/utils/constrains.dart';

//
class OrderProvider {
  // addToOrder
  static addToOrder(uid, OrderModel order) async {
    await MyRepo.refOrder.doc(uid).set(order.toJson()).then((value) async {
      Fluttertoast.showToast(msg: 'Placed order successfully');
    });
  }
  // static addToOrder({
  //   required String uid,
  //   required int total,
  //   required List cartList,
  //   required List idList,
  // }) async {
  //   await refOrder.doc(uid).set({
  //     'uid': uid,
  //     'total': total,
  //     'payment': 'Unpaid',
  //     'status': 'Pending',
  //     'time': DateTime.now(),
  //     'products': cartList,
  //   }).then((value) {
  //     //
  //     for (var id in idList) {
  //       //remove from cart using product id
  //       CartProvider.removeFromCart(id: id, disableToast: true);
  //     }
  //
  //     //
  //     Fluttertoast.showToast(msg: 'Add to order');
  //   });
  // }

  //deleteFrom order

  // addToOrder
  static removeFromStock(uid, quantity) async {
    await MyRepo.refProducts.doc(uid).get().then((value) async {
      //
      int stockQuantity = value.get('stockQuantity');
      if (stockQuantity != 0) {
        await MyRepo.refProducts.doc(uid).update(
            {'stockQuantity': stockQuantity - quantity}).then((value) async {
          Fluttertoast.showToast(msg: 'Placed order successfully');
        });
      }
    });
  }

  //remove from order
  static removeFromOrder({required String orderId}) async {
    await MyRepo.refOrder.doc(orderId).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from order');
    });
  }
}
