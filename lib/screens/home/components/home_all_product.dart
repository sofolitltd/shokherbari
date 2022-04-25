import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/product_model.dart';
import '/screens/product/product_all.dart';
import '/utils/constrains.dart';
import '/widgets/product_card.dart';

class AllProductHome extends StatelessWidget {
  const AllProductHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 250,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Text('All products',
                    style: Theme.of(context).textTheme.headline6),
              ),

              //
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ProductAll()));
                  },
                  child: const Text('see more >'))
            ],
          ),

          //
          Container(
            constraints: const BoxConstraints(
              minHeight: 300,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: MyRepo.refProducts.limit(24).snapshots(),
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

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: .7,
                  ),
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  itemBuilder: (_, index) {
                    ProductModel product =
                        ProductModel.fromSnapshot(data[index]);
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
