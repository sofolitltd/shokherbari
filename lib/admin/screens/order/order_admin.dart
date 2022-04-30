import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/admin/models/order_model_admin.dart';
import 'package:shokher_bari/admin/screens/order/widgets/order_card_admin.dart';

import '/admin/utils/constraints.dart';

class OrderAdmin extends StatelessWidget {
  const OrderAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Manage'),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream:
              AdminRepo.refOrder.orderBy('time', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.size == 0) {
              return const Center(child: Text('No order found'));
            }

            var data = snapshot.data!.docs;

            //
            return ListView.separated(
              // shrinkWrap: true,
              itemCount: data.length,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemBuilder: (context, index) {
                OrderModelAdmin order =
                    OrderModelAdmin.fromSnapshot(data[index]);

                //
                return OrderCardAdmin(order: order);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 8),
            );
          }),
    );
  }
}
