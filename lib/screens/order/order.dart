import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shokher_bari/models/cart_list.dart';
import 'package:shokher_bari/models/product_model.dart';

import '/models/order_model.dart';
import '/provider/order_provider.dart';
import '/utils/constrains.dart';

class Order extends StatelessWidget {
  const Order({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        elevation: 0.1,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),

      // order body
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // cart product
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  MyRepo.refOrder.orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data!.docs;
                if (data.isEmpty) {
                  return const Center(child: Text('No product found'));
                }

                //
                return ListView.builder(
                    itemCount: data.length,
                    padding: const EdgeInsets.all(4),
                    itemBuilder: (context, index) {
                      OrderModel order = OrderModel.fromSnapshot(data[index]);

                      //
                      String orderTime = DateFormat('dd MMMM, yyyy  ~ ')
                          .add_jm()
                          .format(order.time.toDate())
                          .toString();

                      //
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 4),
                        elevation: 2,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // order, placed on
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //
                                      Row(
                                        children: [
                                          const Text('Order Id: '),

                                          //
                                          Text(
                                            order.orderId,
                                            style: const TextStyle(
                                                color: Colors.purple),
                                          ),
                                        ],
                                      ),

                                      //
                                      Text('Placed on:  $orderTime'),
                                    ],
                                  ),

                                  //
                                  IconButton(
                                      onPressed: () {
                                        //
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title:
                                                const Text('Delete from order'),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      //removeFromOrder
                                                      OrderProvider
                                                          .removeFromOrder(
                                                              orderId: order
                                                                  .orderId);
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
                                      icon:
                                          const Icon(Icons.more_vert_rounded)),
                                ],
                              ),
                            ),

                            const Divider(),

                            // cart product list
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: order.productList.length,
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              itemBuilder: (context, index) {
                                CartList cartList = CartList.fromSnapshot(
                                    order.productList[index]);
                                //
                                return OrderCard(cartList: cartList);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 4),
                            ),

                            const Divider(),

                            // status, items, total
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // status
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          data[index].get('status') == 'Pending'
                                              ? Colors.red
                                              : data[index].get('status') ==
                                                      'Processing'
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

                                  //
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //items
                                      // Text('${products.length} items, '),

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
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

//
class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.cartList}) : super(key: key);
  final CartList cartList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: MyRepo.refProducts.doc(cartList.productId).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //
          DocumentSnapshot productData = snapshot.data;
          ProductModel product = ProductModel.fromSnapshot(productData);

          return Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // category, subcategory
                  // Row(
                  //   children: [
                  //     // category
                  //     Text(
                  //       product.category,
                  //       style: const TextStyle(
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //
                  //     const Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 4),
                  //       child: Icon(Icons.arrow_forward_ios_outlined, size: 10),
                  //     ),
                  //
                  //     // subcategory
                  //     Text(
                  //       product.subcategory,
                  //       style: const TextStyle(
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  //
                  // const Divider(height: 8),

                  //image, info
                  Row(
                    children: [
                      //image
                      Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade100.withOpacity(.2),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(product.images[0]),
                          ),
                        ),
                      ),

                      // title , price
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name
                              Container(
                                constraints:
                                    const BoxConstraints(minHeight: 36),
                                child: Text(
                                  product.name,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1.3),
                                ),
                              ),

                              // sale price
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // sale price x qty
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // offer price
                                      Row(
                                        children: [
                                          Text(
                                            'Price: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          Text(
                                            '$kTk ${product.salePrice}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(color: Colors.red),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(width: 5),

                                      //qty
                                      Row(
                                        children: [
                                          Text(
                                            'Qty: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!,
                                          ),
                                          Text(
                                            '${cartList.quantity}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //sub total
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Subtotal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),

                                      //
                                      Text(
                                        '$kTk ${product.salePrice * cartList.quantity}',
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
