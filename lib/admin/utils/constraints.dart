import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shokher_bari/admin/screens/banner/all_banner_admin.dart';
import 'package:shokher_bari/admin/screens/category/all_category_admin.dart';
import 'package:shokher_bari/admin/screens/delivery/delivery_admin.dart';
import 'package:shokher_bari/admin/screens/order/order_admin.dart';
import 'package:shokher_bari/admin/screens/product/all_product_admin.dart';

class AdminRepo {
  //
  static List screenList = [
    const AllBannerAdmin(),
    const OrderAdmin(),
    const AllProductAdmin(),
    const AllCategoryAdmin(),
    const DeliveryAdmin(),
  ];

  // firestore
  static final ref = FirebaseFirestore.instance;

  //orders
  static final refOrder = ref.collection('Orders');
}
