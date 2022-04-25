import 'package:flutter/material.dart';
import 'package:shokher_bari/admin/screens/delivery/delivery_admin.dart';

import '/admin/screens/banner/all_banner_admin.dart';
import '/admin/screens/category/all_category_admin.dart';
import '/admin/screens/order/manage_orders.dart';
import '/admin/screens/product/all_product_admin.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // add banner
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllBannerAdmin()));
            },
            leading: const Icon(Icons.vrpano_outlined),
            title: const Text('Add Banner'),
          ),

          // delivery charge
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DeliveryAdmin()));
            },
            leading: const Icon(Icons.monetization_on_rounded),
            title: const Text('Delivery Charge'),
          ),

          const Divider(),

          // add category
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllCategoryAdmin()));
            },
            leading: const Icon(Icons.calendar_view_month_outlined),
            title: const Text('Add Category'),
          ),

          const Divider(),

          // add product
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllProductAdmin()));
            },
            leading: const Icon(Icons.style_outlined),
            title: const Text('Add Product'),
          ),

          const Divider(),

          // manage orders
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageOrders()));
            },
            leading: const Icon(Icons.dynamic_form_outlined),
            title: const Text('Manage Orders'),
          ),

          const Divider(),
        ],
      ),
    );
  }
}
