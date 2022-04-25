import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/product_model.dart';
import '/utils/constrains.dart';
import '/widgets/product_card.dart';

class FeaturedProductHome extends StatelessWidget {
  const FeaturedProductHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: Divider(thickness: 2)),
                //
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text('Featured Products',
                      style: Theme.of(context).textTheme.headline6),
                ),

                const Expanded(child: Divider(thickness: 2)),
              ],
            ),
          ),

          //list
          SizedBox(
            height: 275,
            child: StreamBuilder<QuerySnapshot>(
                stream: MyRepo.refProducts
                    .where('featured', isEqualTo: true)
                    .limit(12)
                    .snapshots(),
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

                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    padding: const EdgeInsets.fromLTRB(12, 8, 0, 10),
                    itemBuilder: (_, index) {
                      ProductModel product =
                          ProductModel.fromSnapshot(data[index]);

                      return ProductCard(product: product);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 12),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
