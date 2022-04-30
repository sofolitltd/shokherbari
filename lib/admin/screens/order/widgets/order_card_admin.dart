import 'package:flutter/material.dart';

import '/admin/models/order_model_admin.dart';
import '/admin/provider_admin/order_provider_admin.dart';
import '/utils/constrains.dart';
import '../orders_details_admin.dart';

class OrderCardAdmin extends StatelessWidget {
  const OrderCardAdmin({
    Key? key,
    required this.order,
  }) : super(key: key);
  final OrderModelAdmin order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailAdmin(
              order: order,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //time
            Text(OrderProviderAdmin.time(order),
                style: const TextStyle(color: Colors.black54)),

            const SizedBox(height: 4),
            // id
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    //id
                    Text('#${order.orderId}'),

                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(order.email.split('@').first),
                    ),
                  ],
                ),

                //total
                Text('$kTk ${order.total}'),
              ],
            ),

            const SizedBox(height: 8),

            //
            Container(
              constraints: const BoxConstraints(minWidth: 110),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                color: statusColor(order.status),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                order.status,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
statusColor(String status) {
  if (status == 'Pending') {
    return Colors.red;
  } else if (status == 'Processing') {
    return Colors.blue;
  } else if (status == 'Completed') {
    return Colors.green;
  }
  return Colors.grey;
}
