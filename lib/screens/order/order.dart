import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shokher_bari/models/cart_list.dart';

import '/models/order_model.dart';
import '/utils/constrains.dart';
import '../../provider/order_provider.dart';

class Order extends StatelessWidget {
  const Order({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        elevation: 0.1,
      ),

      // order body
      body: StreamBuilder<QuerySnapshot>(
        stream: UserRepo.refOrder
            .where('email', isEqualTo: UserRepo.userEmail)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.docs;
          if (data.isEmpty) {
            return const Center(child: Text('No order found'));
          }

          //
          return ListView.separated(
              itemCount: data.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                OrderModel order = OrderModel.fromSnapshot(data[index]);

                // time convert
                String orderTime = DateFormat('dd MMMM, yyyy ~')
                    .add_jm()
                    .format(order.time.toDate())
                    .toString();

                // order
                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // order, placed on
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                Row(
                                  children: [
                                    const Text('Order Id:'),

                                    const SizedBox(width: 8),
                                    //
                                    Text(
                                      '# ${order.orderId}',
                                      style:
                                          const TextStyle(color: Colors.purple),
                                    ),
                                  ],
                                ),

                                //
                                Text('Placed on: $orderTime'),
                              ],
                            ),

                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  //
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete from order'),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                //removeFromOrder
                                                OrderProvider.removeFromOrder(
                                                    orderId: order.orderId);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Delete'),
                                            ),

                                            const SizedBox(width: 8),

                                            //
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.more_vert_rounded)),
                          ],
                        ),
                      ),

                      const Divider(height: 4),

                      // product title
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Products',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // cart product list
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: order.productList.length,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index) {
                          CartList cartList =
                              CartList.fromSnapshot(order.productList[index]);

                          //order card
                          return OrderCard(product: cartList);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          height: 4,
                        ),
                      ),

                      const Divider(),

                      // delivery
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Delivery charge',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text('$kTk ${order.delivery}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    )),
                          ],
                        ),
                      ),

                      // charge
                      if (order.method == 'Bkash')
                        Column(
                          children: [
                            // const Divider(),

                            // charge
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '*cash out charge ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                  Text(
                                    '$kTk ${order.charge}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.red),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                      const Divider(),

                      // status, total
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // status
                            Container(
                              decoration: BoxDecoration(
                                color: data[index].get('status') == 'Pending'
                                    ? Colors.red
                                    : data[index].get('status') == 'Processing'
                                        ? Colors.blue
                                        : Colors.green, // Cancelled
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 12,
                              ),
                              child: Text(
                                '${data[index].get('status')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            //
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: order.method == 'Bkash'
                                    ? Colors.pink.shade300
                                    : Colors.black54,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                order.method,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ),

                            const Spacer(),

                            //
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //title
                                const Text('Total:'),

                                const SizedBox(width: 8),

                                // total
                                Text(
                                  '$kTk ${data[index].get('total')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12));
        },
      ),
    );
  }
}

//
class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.product}) : super(key: key);
  final CartList product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Row(
            children: [
              //image
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.pink.shade100.withOpacity(.2),
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(product.image),
                  ),
                ),
              ),

              // title , price
              Expanded(
                child: IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //name
                        Text(
                          product.name,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    // height: 1.3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                        ),

                        const SizedBox(height: 8),

                        //qty, price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //
                            Row(
                              children: [
                                //
                                Text(
                                  '$kTk ${product.price}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.red),
                                ),

                                //
                                const Text(' x '),

                                //
                                Text(
                                  '${product.quantity}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.red),
                                ),
                              ],
                            ),

                            //
                            Text(
                              '$kTk ${product.price * product.quantity}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
