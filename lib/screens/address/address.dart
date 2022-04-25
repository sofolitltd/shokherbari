import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_stepper/stepper.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '../../models/address_book.dart';
import '../payment/checkout_payment.dart';
import 'add_address.dart';

class Address extends StatefulWidget {
  const Address({
    Key? key,
    required this.total,
    required this.productId,
    required this.productList,
  }) : super(key: key);

  final int total;
  final List productId;
  final List productList;

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String _selectedAddress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout(1/2)')),

      //
      body: Column(
        children: [
          // stepper
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: IconStepper(
                    enableNextPreviousButtons: false,
                    activeStepBorderWidth: 2,
                    stepColor: Colors.transparent,
                    activeStepColor: Colors.transparent,
                    activeStepBorderColor: Colors.transparent,
                    activeStepBorderPadding: 0,
                    lineColor: Colors.grey,
                    lineLength: 85,
                    lineDotRadius: 2,
                    icons: [
                      const Icon(
                        Icons.adjust,
                        color: Colors.orange,
                      ),
                      Icon(
                        Icons.adjust,
                        color: Colors.grey.shade500,
                      ),
                      Icon(
                        Icons.adjust,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Delivery address',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Payment method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Order placed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Divider(),

          // select address
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Select Delivery Address'),

                const SizedBox(height: 16),

                // add new address
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AddAddress()));
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Add New Address'),
                  ),
                ),

                const SizedBox(height: 16),

                // hall
                StreamBuilder<DocumentSnapshot>(
                    stream: MyRepo.refAddressHall.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                          constraints: const BoxConstraints(minHeight: 100),
                        ));
                      }

                      if (!snapshot.data!.exists) {
                        return Center(
                            child: Container(
                          constraints: const BoxConstraints(minHeight: 100),
                        ));
                      }

                      //
                      Map<String, Object?> data =
                          snapshot.data!.data() as Map<String, Object?>;
                      var address = AddressModel.fromJson(data);

                      return Container(
                        constraints: const BoxConstraints(minHeight: 100),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // hall icon, title, radio
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.account_balance,
                                  color: Colors.blue,
                                  size: 20,
                                ),

                                const SizedBox(width: 8),

                                // hall title
                                Text(
                                  'Hall',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.blue,
                                      ),
                                ),

                                const Spacer(),

                                //
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAddress = 'Hall';
                                    });
                                  },
                                  child: Icon(
                                    _selectedAddress == 'Hall'
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked_rounded,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 12),

                            // name,  phone and edit
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // name,  phone
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //name
                                    Text(
                                      address.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            fontWeight: FontWeight.w700,
                                            // letterSpacing: .5,
                                          ),
                                    ),

                                    // phone
                                    Text(address.phone,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                  ],
                                ),

                                //edit
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit)),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // address
                            Text(
                              address.address,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),

                            //place
                            Text(
                              address.place,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      );
                    }),

                const SizedBox(height: 8),

                // home
                StreamBuilder<DocumentSnapshot>(
                    stream: MyRepo.refAddressHome.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                          constraints: const BoxConstraints(minHeight: 100),
                        ));
                      }

                      if (!snapshot.data!.exists) {
                        return Center(
                            child: Container(
                          constraints: const BoxConstraints(minHeight: 100),
                        ));
                      }

                      //
                      Map<String, Object?> data =
                          snapshot.data!.data() as Map<String, Object?>;
                      var address = AddressModel.fromJson(data);

                      return Container(
                        constraints: const BoxConstraints(minHeight: 100),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // home icon, title, radio
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.home,
                                  color: Colors.orange,
                                  // size: 20,
                                ),

                                const SizedBox(width: 8),

                                // hall title
                                Text(
                                  'Home',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.orange,
                                      ),
                                ),

                                const Spacer(),

                                //
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAddress = 'Home';
                                    });
                                  },
                                  child: Icon(
                                    _selectedAddress == 'Home'
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked_rounded,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 12),

                            // name,  phone and edit
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // name,  phone
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //name
                                    Text(
                                      address.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            fontWeight: FontWeight.w700,
                                            // letterSpacing: .5,
                                          ),
                                    ),

                                    // phone
                                    Text(address.phone,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                  ],
                                ),

                                //edit
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit)),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // address
                            Text(
                              address.address,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),

                            //place
                            Text(
                              address.place,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),

          //Proceed To Payment
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                if (_selectedAddress.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutPayment(
                        total: widget.total,
                        address: _selectedAddress,
                        productId: widget.productId,
                        productList: widget.productList,
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(msg: 'Please add/select address');
                }
              },
              child: const Text('Proceed To Payment'),
            ),
          ),
        ],
      ),
    );
  }
}
