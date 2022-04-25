import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String email;
  final int total;
  final List productList;
  final String phone;
  final String transaction;
  final String message;
  final String method;
  final String address;
  final Timestamp time;
  final String status;

  OrderModel({
    required this.orderId,
    required this.email,
    required this.total,
    required this.productList,
    required this.phone,
    required this.transaction,
    required this.message,
    required this.method,
    required this.address,
    required this.time,
    required this.status,
  });

  //fetch
  // CartProduct.fromJson(Map<String, Object?> json)
  //     : this(
  //         productId: json['productId']! as String,
  //         quantity: json['quantity']! as int,
  //       );

  // fetch
  static fromSnapshot(json) => OrderModel(
        orderId: json['orderId']! as String,
        email: json['email']! as String,
        total: json['total']! as int,
        productList: json['productList']! as List,
        phone: json['phone']! as String,
        transaction: json['transaction']! as String,
        message: json['message']! as String,
        method: json['method']! as String,
        address: json['address']! as String,
        time: json['time']! as Timestamp,
        status: json['status']! as String,
      );

  // upload
  Map<String, Object?> toJson() {
    return {
      'orderId': orderId,
      'email': email,
      'total': total,
      'productList': productList,
      'phone': phone,
      'transaction': transaction,
      'message': message,
      'method': method,
      'address': address,
      'time': time,
      'status': status,
    };
  }
}
