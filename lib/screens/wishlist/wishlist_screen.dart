import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '/models/product_model.dart';
import '/screens/wishlist/widgets/wishlist_card.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
        elevation: 0.1,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),

      // cart body
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // cart product
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: MyRepo.refWishlist.snapshots(),
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

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (_, index) {
                      var id = data[index].id;
                      return StreamBuilder<DocumentSnapshot>(
                        stream: MyRepo.refProducts.doc(id).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          //
                          var products = snapshot.data!;
                          ProductModel product =
                              ProductModel.fromSnapshot(products);
                          return WishlistCard(product: product);
                        },
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
