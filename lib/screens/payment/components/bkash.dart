import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/models/order_model.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '../../../provider/cart_provider.dart';
import '../../checkout/checkout_order.dart';

class Bkash extends StatefulWidget {
  const Bkash({
    Key? key,
    required this.orderId,
    required this.total,
    required this.charge,
    required this.delivery,
    required this.productId,
    required this.productList,
    required this.address,
  }) : super(key: key);

  final String orderId;
  final int total;
  final int charge;
  final int delivery;
  final List productId;
  final List productList;
  final String address;

  @override
  State<Bkash> createState() => _BkashState();
}

class _BkashState extends State<Bkash> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _transactionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.pink,
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        Container(
          color: Colors.white,
          child: Image.asset(
            'assets/logo/bpay.jpg',
            height: 56,
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            children: [
              // instruction
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      spreadRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Send to: $kBkashAccount',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    //todo: uid
                    Text(
                      'Invoice no: ${widget.orderId} ',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),

                    //
                    Text(
                      'Amount to Pay: BDT ${widget.total}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Form(
                key: _globalKey,
                child: Column(
                  children: [
                    // mobile no
                    Text(
                      'bKash account number',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.white),
                    ),

                    //
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          hintText: 'e.g 01XXXXXXXXX',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                          counterText: '',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLength: 11,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter phone no'
                            : value.length < 11
                                ? 'Phone no must be 11 digits'
                                : null,
                      ),
                    ),

                    // trans id
                    Text(
                      'Enter transaction ID',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.white),
                    ),
                    //
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _transactionController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                          hintText: 'e.g 8XHE39433j',
                          counterText: '',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLength: 10,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter transaction ID'
                            : value.length < 10
                                ? 'Transaction ID must be 10 digits'
                                : null,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              //button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // proceed
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        //
                        if (_globalKey.currentState!.validate()) {
                          //
                          FocusScope.of(context).unfocus();

                          //
                          OrderModel order = OrderModel(
                            orderId: widget.orderId,
                            email: UserRepo.userEmail,
                            total: widget.total,
                            charge: widget.charge,
                            delivery: widget.delivery,
                            productList: widget.productList,
                            phone: _phoneController.text.trim(),
                            transaction: _transactionController.text,
                            message: '',
                            method: 'Bkash',
                            address: widget.address,
                            time: Timestamp.now(),
                            status: kOrderStatus,
                          );

                          //
                          await UserRepo.refOrder
                              .doc(widget.orderId)
                              .set(order.toJson())
                              .then((value) async {
                            Fluttertoast.showToast(
                                msg: 'Placed order successfully');
                          });

                          // remove cart
                          for (var id in widget.productId) {
                            await CartProvider.removeFromCart(
                                id: id, disableToast: true);
                          }

                          //
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      CheckoutOrder(uid: widget.orderId)),
                              (_) => false);
                        }
                      },
                      child: Container(
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xffbd205d),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            'Proceed'.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // cancel
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xffbd205d),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            'Close'.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
