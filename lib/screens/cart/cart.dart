import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/cart_list.dart';
import '/screens/cart/widgets/cart_card.dart';
import '/utils/constrains.dart';
import '../../models/product_model.dart';
import '../address/address.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        elevation: 0,
      ),

      // cart body
      body: StreamBuilder<QuerySnapshot>(
        stream: MyRepo.refCart.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var cartListData = snapshot.data!.docs;
          if (cartListData.isEmpty) {
            return const Center(child: Text('No product found'));
          }

          // total price
          int total = 0;
          List cartProductId = [];
          List cartProductList = [];

          for (var item in cartListData) {
            total += item.get('price') * item.get('quantity') as int;

            //add ids
            cartProductId.add(item.id);

            //
            CartList cartList = CartList(
              productId: item.get('productId'),
              quantity: item.get('quantity'),
              price: item.get('price'),
            );

            // add products
            cartProductList.add(cartList.toJson());
          }
          print(total);
          print(cartProductId);
          print(cartProductList);

          return Column(
            children: [
              //cart list
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: cartListData.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  itemBuilder: (context, index) {
                    //cart
                    CartList cartList =
                        CartList.fromSnapshot(cartListData[index]);

                    // cart products
                    return FutureBuilder<DocumentSnapshot>(
                      future: MyRepo.refProducts.doc(cartList.productId).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Container());
                        }

                        //product model
                        ProductModel product =
                            ProductModel.fromSnapshot(snapshot.data!);

                        return CartCard(
                            product: product, quantity: cartList.quantity);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 12),
                ),
              ),

              // total & check out
              if (cartListData.isNotEmpty)
                Column(
                  children: [
                    //
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Price',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              Text(
                                '$kTk $total',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    //
                    const SizedBox(height: 8),

                    // check out
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
                          // go to address screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Address(
                                        total: total,
                                        productId: cartProductId,
                                        productList: cartProductList,
                                      )));
                        },
                        child: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
