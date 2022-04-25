import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '../../provider_admin/order_provider_admin.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({Key? key}) : super(key: key);

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),

      //
      body: buildStreamBuilder(message),
    );
  }

  //
  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder(message) {
    return StreamBuilder<QuerySnapshot>(
      stream: MyRepo.refPayment.orderBy('uid', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var snap = snapshot.data!.docs;

        if (snap.isEmpty) {
          return const Center(child: Text('No order found'));
        }

        return ListView.separated(
            shrinkWrap: true,
            itemCount: snap.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              var data = snap[index];

              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // invoice
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Invoice number:'),
                            Text('${data.get('uid')}'),
                          ],
                        ),

                        // method
                        Row(
                          children: [
                            Chip(label: Text('${data.get('method')}')),

                            //bkash verify
                            if (data.get('method') != 'cash')
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              titlePadding:
                                                  const EdgeInsets.all(8),
                                              title: const Text(
                                                'Upload Message',
                                              ),
                                              content: TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      'Paste message here',
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 8,
                                                  ),
                                                ),
                                                minLines: 5,
                                                maxLines: 8,
                                                onChanged: (newValue) {
                                                  message = newValue;
                                                },
                                              ),
                                              actions: [
                                                //
                                                ElevatedButton(
                                                    onPressed: () {
                                                      //
                                                      if (message.isNotEmpty &&
                                                          message
                                                                  .split(' ')
                                                                  .length >=
                                                              18) {
                                                        //
                                                        MyRepo.refPayment
                                                            .doc(data.id)
                                                            .update({
                                                          'message': message
                                                        }).then((value) {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Please enter message first');
                                                      }
                                                    },
                                                    child: const Text('upload'))
                                              ],
                                            ));
                                  },
                                  child: const Chip(
                                    backgroundColor: Colors.blue,
                                    label: Text(
                                      'Verify',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),

                    const Divider(height: 1),
                    const SizedBox(height: 6),

                    // bkash / cash
                    data.get('method') == 'cash'
                        ? Row(
                            // cash row
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //total
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total: ${data.get('total')}'),
                                ],
                              ),

                              const SizedBox(width: 8),

                              //
                              // StreamBuilder<DocumentSnapshot>(
                              //     stream: OrderProviderAdmin.refOrder
                              //         .collection(MyRepo.userEmail)
                              //         .doc(data.get('uid'))
                              //         .snapshots(),
                              //     builder: (context, snapshot) {
                              //       if (snapshot.hasError) {
                              //         return Container();
                              //       }
                              //       if (snapshot.connectionState ==
                              //           ConnectionState.waiting) {
                              //         return Container();
                              //       }
                              //       var status = snapshot.data!.get('status');
                              //
                              //       return status == 'Pending'
                              //           ? ElevatedButton(
                              //               onPressed: () async {
                              //                 await OrderProviderAdmin
                              //                     .updateOrderStatus(
                              //                         uid: data.get('uid'));
                              //               },
                              //               child: const Text('Confirm Order'))
                              //           : const Text(
                              //               'Processing',
                              //               style: TextStyle(
                              //                 color: Colors.red,
                              //               ),
                              //             );
                              //     })
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              //
                              Row(
                                children: [
                                  // payment data
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Total: ${data.get('total')}'),
                                      Text('Phone: ${data.get('phone')}'),
                                      Text(
                                          'Transaction: ${data.get('transaction')}'),
                                    ],
                                  ),

                                  const SizedBox(width: 8),

                                  // icon
                                  if (data.get('message').isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //total
                                        '${data.get('total')}' ==
                                                '${OrderProviderAdmin.getTotal(data.get('message'))}'
                                            ? const Icon(Icons.check_circle,
                                                color: Colors.green)
                                            : const Icon(Icons.cancel,
                                                color: Colors.red),

                                        //phone
                                        data.get('phone') ==
                                                '${OrderProviderAdmin.getPhone(data.get('message'))}'
                                            ? const Icon(Icons.check_circle,
                                                color: Colors.green)
                                            : const Icon(Icons.cancel,
                                                color: Colors.red),

                                        //transaction
                                        data.get('transaction') ==
                                                '${OrderProviderAdmin.getTransaction(data.get('message'))}'
                                            ? const Icon(Icons.check_circle,
                                                color: Colors.green)
                                            : const Icon(Icons.cancel,
                                                color: Colors.red),
                                      ],
                                    ),

                                  const SizedBox(width: 8),

                                  // message data
                                  if (data.get('message').isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${OrderProviderAdmin.getTotal(data.get('message'))}'),
                                        Text(
                                            '${OrderProviderAdmin.getPhone(data.get('message'))}'),
                                        Text(
                                            '${OrderProviderAdmin.getTransaction(data.get('message'))}'),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),

                    //
                    // if (data.get('message').isNotEmpty &&
                    //         '${data.get('total')}' ==
                    //             '${OrderProviderAdmin.getTotal(data.get('message'))}' ||
                    //     data.get('phone') ==
                    //             '${OrderProviderAdmin.getPhone(data.get('message'))}' &&
                    //         data.get('transaction') ==
                    //             '${OrderProviderAdmin.getTransaction(data.get('message'))}')
                    //
                    //   //
                    //   StreamBuilder<DocumentSnapshot>(
                    //       stream: OrderProviderAdmin.refOrder
                    //           .collection(MyRepo.userEmail)
                    //           .doc(data.get('uid'))
                    //           .snapshots(),
                    //       builder: (context, snapshot) {
                    //         if (snapshot.hasError) {
                    //           return Container();
                    //         }
                    //         if (snapshot.connectionState ==
                    //             ConnectionState.waiting) {
                    //           return Container();
                    //         }
                    //         var status = snapshot.data!.get('status');
                    //
                    //         return status == 'Pending'
                    //             ? ElevatedButton(
                    //                 onPressed: () async {
                    //                   await OrderProviderAdmin
                    //                       .updateOrderStatus(
                    //                           uid: data.get('uid'));
                    //                 },
                    //                 child: const Text('Confirm Order'))
                    //             : Container(
                    //                 width: double.infinity,
                    //                 alignment: Alignment.centerRight,
                    //                 child: const Text(
                    //                   'Processing',
                    //                   style: TextStyle(
                    //                     color: Colors.red,
                    //                   ),
                    //                 ),
                    //               );
                    //       }),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 8));
      },
    );
  }
}

//old
// class ManageOrders extends StatefulWidget {
//   const ManageOrders({Key? key}) : super(key: key);
//
//   @override
//   State<ManageOrders> createState() => _ManageOrdersState();
// }
//
// class _ManageOrdersState extends State<ManageOrders> {
//   String message = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Manage Orders'),
//       ),
//
//       //
//       body: buildStreamBuilder(message),
//     );
//   }
//
//   //
//   StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder(message) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: OrderProviderAdmin.refPayment
//           .orderBy('uid', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Center(child: Text('Something wrong'));
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         var snap = snapshot.data!.docs;
//
//         if (snap.isEmpty) {
//           return const Center(child: Text('No order found'));
//         }
//
//         return ListView.separated(
//             shrinkWrap: true,
//             itemCount: snap.length,
//             padding: const EdgeInsets.all(8),
//             itemBuilder: (context, index) {
//               var data = snap[index];
//
//               return Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     //
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Invoice number:'),
//                             Text('${data.get('uid')}'),
//                           ],
//                         ),
//
//                         //
//                         Row(
//                           children: [
//                             Chip(label: Text('${data.get('method')}')),
//
//                             //bkash verify
//                             if (data.get('method') != 'cash')
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     showDialog(
//                                         context: context,
//                                         builder: (context) => AlertDialog(
//                                           contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 8),
//                                           titlePadding:
//                                           const EdgeInsets.all(8),
//                                           title: const Text(
//                                             'Upload Message',
//                                           ),
//                                           content: TextField(
//                                             decoration:
//                                             const InputDecoration(
//                                               hintText:
//                                               'Paste message here',
//                                               border: OutlineInputBorder(),
//                                               contentPadding:
//                                               EdgeInsets.symmetric(
//                                                 horizontal: 8,
//                                                 vertical: 8,
//                                               ),
//                                             ),
//                                             minLines: 5,
//                                             maxLines: 8,
//                                             onChanged: (newValue) {
//                                               message = newValue;
//                                             },
//                                           ),
//                                           actions: [
//                                             //
//                                             ElevatedButton(
//                                                 onPressed: () {
//                                                   //
//                                                   if (message.isNotEmpty &&
//                                                       message
//                                                           .split(' ')
//                                                           .length >=
//                                                           18) {
//                                                     //
//                                                     OrderProviderAdmin
//                                                         .refPayment
//                                                         .doc(data.id)
//                                                         .update({
//                                                       'message': message
//                                                     }).then((value) {
//                                                       Navigator.pop(
//                                                           context);
//                                                     });
//                                                   } else {
//                                                     Fluttertoast.showToast(
//                                                         msg:
//                                                         'Please enter message first');
//                                                   }
//                                                 },
//                                                 child: const Text('upload'))
//                                           ],
//                                         ));
//                                   },
//                                   child: const Chip(
//                                     backgroundColor: Colors.blue,
//                                     label: Text(
//                                       'Verify',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                           ],
//                         ),
//                       ],
//                     ),
//
//                     const Divider(height: 1),
//                     const SizedBox(height: 6),
//
//                     // bkash / cash
//                     data.get('method') == 'cash'
//                         ? Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         //
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Total: ${data.get('total')}'),
//                           ],
//                         ),
//
//                         const SizedBox(width: 8),
//
//                         //
//                         StreamBuilder<DocumentSnapshot>(
//                             stream: OrderProvider.refOrder
//                                 .doc(data.get('uid'))
//                                 .snapshots(),
//                             builder: (context, snapshot) {
//                               if (snapshot.hasError) {
//                                 return Container();
//                               }
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return Container();
//                               }
//                               var status = snapshot.data!.get('status');
//
//                               return status == 'Pending'
//                                   ? ElevatedButton(
//                                   onPressed: () async {
//                                     await OrderProviderAdmin
//                                         .updateOrderStatus(
//                                         uid: data.get('uid'));
//                                   },
//                                   child: const Text('Confirm Order'))
//                                   : const Text(
//                                 'Processing',
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                 ),
//                               );
//                             })
//                       ],
//                     )
//                         : Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         //
//                         Row(
//                           children: [
//                             // payment data
//                             Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Text('Total: ${data.get('total')}'),
//                                 Text('Phone: ${data.get('phone')}'),
//                                 Text(
//                                     'Transaction: ${data.get('transaction')}'),
//                               ],
//                             ),
//
//                             const SizedBox(width: 8),
//
//                             // icon
//                             if (data.get('message').isNotEmpty)
//                               Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   //total
//                                   '${data.get('total')}' ==
//                                       '${OrderProviderAdmin.getTotal(data.get('message'))}'
//                                       ? const Icon(Icons.check_circle,
//                                       color: Colors.green)
//                                       : const Icon(Icons.cancel,
//                                       color: Colors.red),
//
//                                   //phone
//                                   data.get('phone') ==
//                                       '${OrderProviderAdmin.getPhone(data.get('message'))}'
//                                       ? const Icon(Icons.check_circle,
//                                       color: Colors.green)
//                                       : const Icon(Icons.cancel,
//                                       color: Colors.red),
//
//                                   //transaction
//                                   data.get('transaction') ==
//                                       '${OrderProviderAdmin.getTransaction(data.get('message'))}'
//                                       ? const Icon(Icons.check_circle,
//                                       color: Colors.green)
//                                       : const Icon(Icons.cancel,
//                                       color: Colors.red),
//                                 ],
//                               ),
//
//                             const SizedBox(width: 8),
//
//                             // message data
//                             if (data.get('message').isNotEmpty)
//                               Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                       '${OrderProviderAdmin.getTotal(data.get('message'))}'),
//                                   Text(
//                                       '${OrderProviderAdmin.getPhone(data.get('message'))}'),
//                                   Text(
//                                       '${OrderProviderAdmin.getTransaction(data.get('message'))}'),
//                                 ],
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//
//                     //
//                     if (data.get('message').isNotEmpty &&
//                         '${data.get('total')}' ==
//                             '${OrderProviderAdmin.getTotal(data.get('message'))}' ||
//                         data.get('phone') ==
//                             '${OrderProviderAdmin.getPhone(data.get('message'))}' &&
//                             data.get('transaction') ==
//                                 '${OrderProviderAdmin.getTransaction(data.get('message'))}')
//
//                     //
//                       StreamBuilder<DocumentSnapshot>(
//                           stream: OrderProvider.refOrder
//                               .doc(data.get('uid'))
//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasError) {
//                               return Container();
//                             }
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Container();
//                             }
//                             var status = snapshot.data!.get('status');
//
//                             return status == 'Pending'
//                                 ? ElevatedButton(
//                                 onPressed: () async {
//                                   await OrderProviderAdmin
//                                       .updateOrderStatus(
//                                       uid: data.get('uid'));
//                                 },
//                                 child: const Text('Confirm Order'))
//                                 : Container(
//                               width: double.infinity,
//                               alignment: Alignment.centerRight,
//                               child: const Text(
//                                 'Processing',
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             );
//                           }),
//                   ],
//                 ),
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) =>
//             const SizedBox(height: 8));
//       },
//     );
//   }
// }
