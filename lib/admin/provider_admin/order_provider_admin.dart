// class OrderProviderAdmin {
//   //getTotal
//   static getTotal(String text) {
//     if (text.isNotEmpty) {
//       List line = text.split(' ');
//       String total = line[4];
//       var t = total.replaceAll(',', '');
//       var f = double.parse(t).toStringAsFixed(0);
//       print(f);
//       return f;
//     }
//   }
//
//   //getPhone
//   static getPhone(String text) {
//     if (text.isNotEmpty) {
//       List line = text.split(' ');
//       var phoneString = line[6].toString();
//       var phone = phoneString.substring(0, phoneString.length - 1);
//       return phone;
//     }
//   }
//
//   //getTransaction
//   static getTransaction(String text) {
//     if (text.isNotEmpty) {
//       List line = text.split(' ');
//       var transaction = line.length > 18 ? line[16] : line[14];
//       return transaction;
//     }
//   }
//
//   //checkMessage
//   static checkMessage(QueryDocumentSnapshot data) {
//     if (data.get('total').toString() ==
//             getTotal(data.get('message').toString()) &&
//         data.get('phone') == getPhone(data.get('message')) &&
//         data.get('transaction') == getTransaction(data.get('message'))) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   //checkStatus
//   static checkStatus(uid) async {
//     await MyRepo.refOrder.doc(uid).get().then(
//       (value) {
//         var status = value.get('status');
//         // print(status);
//         return status;
//       },
//     );
//   }
//
//   //updateOrderStatus
//   static updateOrderStatus({required String uid}) async {
//     await MyRepo.refOrder
//         .doc(uid)
//         .update({'status': 'Processing'}).then((value) {});
//   }
//
//   //updateOrderStatus
//   static updatePaymentMessage({required String uid}) async {
//     await MyRepo.refOrder
//         .doc(uid)
//         .update({'status': 'Processing'}).then((value) {});
//   }
// }

import 'package:intl/intl.dart';
import 'package:shokher_bari/admin/models/order_model_admin.dart';

class OrderProviderAdmin {
  static time(OrderModelAdmin order) {
    // time convert
    String time = DateFormat('dd MMMM, yyyy')
        // .add_jm()
        .format(order.time.toDate())
        .toString();

    return time;
  }
}
