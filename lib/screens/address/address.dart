import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_stepper/stepper.dart';
import 'package:shokher_bari/screens/address/components/address_hall.dart';
import 'package:shokher_bari/screens/address/components/address_home.dart';

import '../../models/address_book.dart';
import '../../utils/constrains.dart';
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
  int _deliveryCharge = 0;

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
                      'Place Order',
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

          //  address
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                // address col
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //address title
                      Text(
                        'Select Delivery Address',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),

                      const Divider(),

                      // address list
                      StreamBuilder<QuerySnapshot>(
                          stream: UserRepo.refAddress.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                  // color: Colors.red,
                                  height:
                                      MediaQuery.of(context).size.height * .42,
                                  child: const Center(
                                      child: CircularProgressIndicator()));
                            }
//
                            List data = snapshot.data!.docs;

                            //
                            if (snapshot.data!.size == 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // add new address
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const AddAddress()));
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                    label: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: Text('Add New Address'),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  const Text(
                                    'No Address found',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            }

                            //
                            if (snapshot.data!.size == 1) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // add new address
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const AddAddress()));
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                    label: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: Text('Add Another Address'),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  //
                                  addressCard(data)
                                ],
                              );
                            }

                            //
                            if (snapshot.data!.size == 2) {
                              return addressCard(data);
                            }

                            return const Text('Loading...');
                          }),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // delivery
                      Text(
                        'Delivery Option',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),

                      const Divider(),

                      // delivery option
                      Row(
                        children: [
                          //
                          const Icon(Icons.radio_button_checked),

                          const SizedBox(width: 16),
                          //
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                Text(
                                  'Regular Delivery',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'order will delivery on next day',
                                  style: Theme.of(context).textTheme.bodyText2,
                                )
                              ],
                            ),
                          ),

                          //
                          StreamBuilder<DocumentSnapshot>(
                              stream: UserRepo.refDelivery.snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CupertinoActivityIndicator());
                                }

                                //
                                _deliveryCharge = snapshot.data!.get('charge');

                                //
                                return Text(
                                  '$kTk $_deliveryCharge',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                );
                              })
                        ],
                      )
                    ],
                  ),
                ),
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
                        delivery: _deliveryCharge,
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

  // address card
  ListView addressCard(List data) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          //
          AddressModel address = AddressModel.fromSnapshot(data[index]);
          //
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
                    Icon(
                      data[index].id == 'Hall'
                          ? Icons.account_balance
                          : Icons.home,
                      color: Colors.blue,
                      size: 20,
                    ),

                    const SizedBox(width: 8),

                    // hall title
                    Text(
                      data[index].id,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.blue,
                          ),
                    ),

                    const Spacer(),

                    //
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAddress = data[index].id;
                        });
                      },
                      child: Icon(
                        _selectedAddress == data[index].id
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 28,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 10),

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
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    // letterSpacing: .5,
                                  ),
                        ),

                        // phone
                        Text(address.phone,
                            style: Theme.of(context).textTheme.subtitle2),
                      ],
                    ),

                    //edit
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => data[index].id == 'Hall'
                                      ? AddressHall(address: address)
                                      : AddressHome(address: address)));
                        },
                        icon: const Icon(Icons.edit)),
                  ],
                ),

                const SizedBox(height: 4),

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
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 8));
  }
}
