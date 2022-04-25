import '../utils/constrains.dart';

class ExtraProvider {
  // get order id
  static getOrderId() async {
    int orderId = 0;

    await MyRepo.ref.collection('Extra').doc('Order').get().then((value) {
      orderId = value.get('orderId') + 1;
    });

    return orderId;
  }

  // update order
  static updateOrderId({required int orderId}) async {
    await MyRepo.ref.collection('Extra').doc('Order').update({
      'orderId': orderId,
    });
  }
}
