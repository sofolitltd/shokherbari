import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/product_model.dart';
import '/utils/constrains.dart';
import '/widgets/product_card.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key, this.category, this.subcategory, this.shortBy})
      : super(key: key);
  final String? category;
  final String? subcategory;
  final String? shortBy;

  @override
  Widget build(BuildContext context) {
    var ref = subcategory == ''
        ? MyRepo.refProducts.where('category', isEqualTo: category)
        : MyRepo.refProducts
            .where('category', isEqualTo: category)
            .where('subcategory', isEqualTo: subcategory);
    return Container(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * .5),
      child: StreamBuilder<QuerySnapshot>(
        stream: shortBy == MyRepo.shortByList[1]
            ? ref.where(shortBy!.toLowerCase(), isEqualTo: true).snapshots()
            : shortBy == MyRepo.shortByList[2]
                ? ref.orderBy('salePrice', descending: false).snapshots()
                : shortBy == MyRepo.shortByList[3]
                    ? ref.orderBy('salePrice', descending: true).snapshots()
                    : ref.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong ${snapshot.error}'));
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
            padding: const EdgeInsets.all(12),
            itemBuilder: (_, index) {
              ProductModel product = ProductModel.fromSnapshot(data[index]);
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}
