import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shokher_bari/models/address_book.dart';
import 'package:shokher_bari/provider/extra_provider.dart';

import '/utils/constrains.dart';
import '../../models/order_model.dart';
import '../../provider/cart_provider.dart';
import '../../provider/order_provider.dart';
import '../../utils/constrains.dart';
import '../checkout/checkout_order.dart';
import 'components/bkash.dart';

class CheckoutPaymentDetails extends StatefulWidget {
  const CheckoutPaymentDetails({
    Key? key,
    required this.method,
    required this.delivery,
    required this.total,
    required this.productId,
    required this.productList,
    required this.address,
  }) : super(key: key);

  final String method;
  final int delivery;
  final int total;
  final List productId;
  final List productList;
  final String address;

  @override
  State<CheckoutPaymentDetails> createState() => _CheckoutPaymentDetailsState();
}

class _CheckoutPaymentDetailsState extends State<CheckoutPaymentDetails> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.method),
      ),

      //
      body: Column(
        children: [
          //
          StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return Container();
              }),

          widget.method == 'bkash'
              ? paymentWithBkash(context)
              : paymentWithCash(context),

          // confirm payment
          SizedBox(
            height: 50,
            width: double.infinity,
            child: _isLoading
                ? Container(
                    color: Colors.black12,
                    child: const Center(child: CircularProgressIndicator()))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () async {
                      int orderId = 0;

                      // order no
                      orderId = await ExtraProvider.getOrderId();

                      // bkash
                      if (widget.method == 'bkash') {
                        showDialog(
                          context: context,
                          builder: (context) => Bkash(
                            orderId: orderId.toString(),
                            charge: int.parse(
                                (widget.total * 0.02).toStringAsFixed(0)),
                            delivery: widget.delivery,
                            total: int.parse((widget.total +
                                    (widget.total * 0.02) +
                                    widget.delivery)
                                .toStringAsFixed(0)),
                            productList: widget.productList,
                            productId: widget.productId,
                            address: widget.address,
                          ),
                        );
                      } else {
                        // start loading
                        setState(() => _isLoading = true);

                        //
                        OrderModel order = OrderModel(
                          orderId: orderId.toString(),
                          email: UserRepo.userEmail,
                          total: widget.total + widget.delivery,
                          charge: 0,
                          delivery: widget.delivery,
                          productList: widget.productList,
                          phone: '',
                          transaction: '',
                          message: '',
                          method: 'Cash',
                          address: widget.address,
                          time: Timestamp.now(),
                          status: kOrderStatus,
                        );

                        //add order
                        await OrderProvider.addToOrder(
                            orderId.toString(), order);

                        //remove from stock
                        for (var id in widget.productId) {
                          UserRepo.refCart.doc(id).get().then((value) async {
                            var qty = value.get('quantity');
                            await OrderProvider.removeFromStock(id, qty);
                          });
                        }

                        // update order id
                        await ExtraProvider.updateOrderId(orderId: orderId);

                        // remove cart
                        for (var id in widget.productId) {
                          await CartProvider.removeFromCart(
                              id: id, disableToast: true);
                        }

                        // stop loading
                        setState(() => _isLoading = false);

                        //go to order page
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    CheckoutOrder(uid: orderId.toString())),
                            (_) => false);
                      }
                    },
                    child: const Text('Confirm Order'),
                  ),
          ),
        ],
      ),
    );
  }

  // paymentWithBkash
  Widget paymentWithBkash(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          //title
          const Text('You should follow some steps to complete your payment.'),
          const SizedBox(height: 8),
          const Text('* Payment with App'),

          //instruction
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('1. open Bkash App'),
                Text('2. Select Send Money'),
                Text('3. Enter Number: $kBkashAccount'),
                Text('4. Enter Amount'),
                Text('5. Enter Pin to Confirm'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          //
          const Text('Send Money to: '),
          const SizedBox(height: 4),

          // number
          GestureDetector(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: kBkashAccount))
                  .then((value) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    content: Text('Copy to clipboard'),
                  ));
              });
            },
            child: Row(
              children: const [
                Icon(Icons.copy, size: 20),

                SizedBox(width: 4),
                //
                Text(
                  kBkashAccount,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // address title
          Text('* Address (${widget.address})'),

          // address
          StreamBuilder<DocumentSnapshot>(
              stream: widget.address == 'Hall'
                  ? UserRepo.refAddressHall.snapshots()
                  : UserRepo.refAddressHome.snapshots(),
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
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

          // address

          const SizedBox(height: 16),

          //
          // const Text('* Order ID'),
          // Container(
          //   color: Colors.white,
          //   padding: const EdgeInsets.all(8),
          //   child: Text('Order tracking id: #${widget.method}'),
          // ),
          //
          // const SizedBox(height: 16),

          // total block
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                    Text('$kTk ${widget.delivery}',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            )),
                  ],
                ),

                const Divider(),

                // charge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '*Cash out charge ',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                    Text(
                      '$kTk ${(widget.total * 0.02).toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.red),
                    )
                  ],
                ),

                const Divider(),

                // subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal ',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      '$kTk ${widget.total}',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.red),
                    )
                  ],
                ),

                const Divider(),

                // total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      '$kTk ' +
                          (widget.total +
                                  (widget.total * 0.02) +
                                  widget.delivery)
                              .toStringAsFixed(0),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //paymentWithCash
  Widget paymentWithCash(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          //title
          const Text('Cash on Delivery'),
          const SizedBox(height: 8),

          // address title
          Text('* Address (${widget.address})'),

          // address
          StreamBuilder<DocumentSnapshot>(
              stream: widget.address == 'Hall'
                  ? UserRepo.refAddressHall.snapshots()
                  : UserRepo.refAddressHome.snapshots(),
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
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

          const SizedBox(height: 16),

          // total block
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                    Text('$kTk ${widget.delivery}',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            )),
                  ],
                ),

                const Divider(),

                // total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      '$kTk ${widget.total + widget.delivery}',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.red),
                    )
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
