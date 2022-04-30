import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/admin/models/order_model_admin.dart';
import '/admin/provider_admin/order_provider_admin.dart';
import '/admin/utils/call_mobile_admin.dart';
import '/admin/utils/constraints.dart';
import '/admin/utils/mail_send_admin.dart';
import '/utils/constrains.dart';
import '../../../models/address_book.dart';
import 'widgets/order_card_admin.dart';

enum Status { pending, processing, completed }

class OrderDetailAdmin extends StatelessWidget {
  const OrderDetailAdmin({Key? key, required this.order}) : super(key: key);
  final OrderModelAdmin order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.greenAccent.shade100,
      appBar: AppBar(
        title: Text('Order #${order.orderId}'),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // name and status
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // id and date
                Row(
                  children: [
                    //time
                    Text(OrderProviderAdmin.time(order)),

                    //
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.brightness_1,
                        size: 8,
                      ),
                    ),

                    //oder
                    Text('#${order.orderId}'),
                  ],
                ),

                // user name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    order.email.split('@').first,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),

                // status, edit
                StreamBuilder<DocumentSnapshot>(
                    stream: AdminRepo.refOrder.doc(order.orderId).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      var status = snapshot.data!.get('status');

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // status
                          Container(
                            constraints: const BoxConstraints(minWidth: 110),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: statusColor(status),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              status,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          //edit
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: StatusDialog(
                                              orderId: order.orderId,
                                              status: status),
                                        ));
                              },
                              child: const Icon(Icons.edit)),
                        ],
                      );
                    }),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // payment
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                Text(
                  'Payment',
                  style: Theme.of(context).textTheme.headline6,
                ),

                const Divider(),

                //
                Column(
                  children: [
                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // method title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Method',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),

                            //
                            Text(order.method,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),

                        //
                        if (order.method == 'Bkash')
                          Container(
                            padding: const EdgeInsets.only(),
                            child: Column(
                              children: [
                                const Divider(),

                                // transaction[bkash]
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //phone
                                    Text(
                                      'Mobile No :',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),

                                    // transaction
                                    Text(order.phone,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),

                                //transaction[bkash]
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //phone
                                    Text(
                                      'Transaction :',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),

                                    // transaction
                                    Text(order.transaction,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),

                                //
                                Column(
                                  children: [
                                    // const Divider(),

                                    // charge
                                    Row(
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const Divider(),

                    // delivery
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery charge',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '$kTk ${order.delivery}',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),

                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Total',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          '$kTk ${order.total}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // product list
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      'Products',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    tilePadding: EdgeInsets.zero,
                    children: [
                      //
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: order.productList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var product = order.productList[index];

                          //
                          return Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  //image
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade200,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(product['image']),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'].toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        //
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // qty, price
                                            Text(
                                                '$kTk ${product['price']} x ${product['quantity']}'),

                                            // total
                                            Text(
                                                '$kTk ${product['quantity'] * product['price']}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 1),
                      ),

                      //
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // shipping
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //address
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const Divider(),

                    // address
                    StreamBuilder<DocumentSnapshot>(
                        stream: order.address == 'Hall'
                            ? UserRepo.refAddressHall.snapshots()
                            : UserRepo.refAddressHome.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          //
                          Map<String, Object?> data =
                              snapshot.data!.data() as Map<String, Object?>;
                          var address = AddressModel.fromJson(data);

                          return Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // name
                                    Text(
                                      address.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            // letterSpacing: .5,
                                          ),
                                    ),

                                    const SizedBox(height: 8),

                                    // address
                                    Text(
                                      address.address,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),

                                    //place
                                    Text(
                                      address.place,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),

                                const Divider(),

                                //mobile
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //
                                    Text(address.phone),

                                    // call
                                    GestureDetector(
                                      onTap: () {
                                        // call mobile
                                        callMobileAdmin(address.phone);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            // color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.call)),
                                    )
                                  ],
                                ),

                                const Divider(),
                                //email
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //
                                    Text(order.email),

                                    // call
                                    GestureDetector(
                                      onTap: () {
                                        //email
                                        mailSendAdmin(order, address);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            // color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.email)),
                                    )
                                  ],
                                ),

                                const Divider(),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
class StatusDialog extends StatefulWidget {
  const StatusDialog({Key? key, required this.orderId, required this.status})
      : super(key: key);

  final String orderId;
  final String status;

  @override
  State<StatusDialog> createState() => _StatusDialogState();
}

class _StatusDialogState extends State<StatusDialog> {
  String? _status = '';

  @override
  void initState() {
    _status = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //title
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text('Change Order Status',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500)),
        ),
        //
        // const Divider(height: 4),

        // radio
        Column(
          children: [
            //
            RadioListTile<String>(
              title: const Text('Pending'),
              value: 'Pending',
              groupValue: _status,
              onChanged: (String? value) {
                setState(() {
                  _status = value;
                });
              },
            ),

            //
            RadioListTile<String>(
              title: const Text('Processing'),
              value: 'Processing',
              groupValue: _status,
              onChanged: (String? value) {
                setState(() {
                  _status = value;
                });
              },
            ),

            //
            RadioListTile<String>(
              title: const Text('Completed'),
              value: 'Completed',
              groupValue: _status,
              onChanged: (String? value) {
                setState(() {
                  _status = value;
                });
              },
            ),
          ],
        ),

        // button
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //cancel
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),

              const SizedBox(width: 8),
              //apply
              TextButton(
                  onPressed: () async {
                    //update status
                    await AdminRepo.refOrder
                        .doc(widget.orderId)
                        .update({'status': _status});

                    //
                    Navigator.pop(context);
                  },
                  child: const Text('Apply')),
            ],
          ),
        )
      ],
    );
  }
}
