import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/admin/screens/product/edit_product.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '/models/product_model.dart';
import '../../provider_admin/product_provider_admin.dart';
import 'add_product.dart';

class AllProductAdmin extends StatelessWidget {
  const AllProductAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
      ),

      //
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProduct()));
        },
        label: const Text('Add Product'),
        icon: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: UserRepo.refProducts.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.docs;

            if (data.isEmpty) {
              return const Center(child: Text('No product found'));
            }

            UserRepo.refProducts.where('stock', isEqualTo: 0).get();

            //
            return SingleChildScrollView(
              child: Column(
                children: [
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total Products: ',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),

                      //
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 3),
                        ),
                        child: Text(data.length.toString()),
                      ),

                      //
                      const SizedBox(width: 8),
                    ],
                  ),

                  //
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (_, index) {
                        ProductModel product =
                            ProductModel.fromSnapshot(data[index]);

                        //
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              children: [
                                //image
                                Expanded(
                                  flex: 3,
                                  child: Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      //image
                                      IntrinsicWidth(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            minHeight: 120,
                                            maxHeight: 120,
                                          ),
                                          child: IntrinsicHeight(
                                            child: Image.network(
                                              product.images[0],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),

                                      //new / featured
                                      product.featured
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 8),
                                              margin: const EdgeInsets.only(
                                                  left: 4, bottom: 4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Colors.green.shade300,
                                              ),
                                              child: const Text(
                                                'Featured',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            )
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 8),
                                              margin: const EdgeInsets.only(
                                                  left: 4, bottom: 4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Colors.yellow.shade300,
                                              ),
                                              child: const Text(
                                                'Sale',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // info
                                Expanded(
                                  flex: 8,
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      //
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 8, 8, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //category name
                                            Row(
                                              children: [
                                                //category
                                                Text(
                                                  '${product.category} > ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),

                                                //subcategory
                                                Text(
                                                  product.subcategory,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ],
                                            ),

                                            //product name
                                            Text(
                                              product.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),

                                            // price
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                //price
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    //offer price
                                                    Text(
                                                      '$kTk ${product.salePrice}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1!
                                                          .copyWith(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),

                                                    const SizedBox(width: 8),

                                                    // regular price
                                                    if (product.regularPrice !=
                                                        0)
                                                      Text(
                                                        '$kTk ${product.regularPrice}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2!
                                                            .copyWith(
                                                                color:
                                                                    Colors.grey,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            // weight, stock
                                            Row(
                                              children: [
                                                //weight
                                                Row(
                                                  children: [
                                                    //qty title
                                                    Text(
                                                      'Weight:  ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),

                                                    //weight
                                                    Text(
                                                      product.weight == ''
                                                          ? 'N/A'
                                                          : product.weight,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2!
                                                          .copyWith(
                                                            color: Colors.red,
                                                          ),
                                                    ),
                                                  ],
                                                ),

                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child: Text('|'),
                                                ),

                                                //stock
                                                Row(
                                                  children: [
                                                    //qty title
                                                    Text(
                                                      'Stock:  ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),

                                                    //stock
                                                    Text(
                                                      '${product.stockQuantity}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1!
                                                          .copyWith(
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // menu btn
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () async {
                                            productBottomSheet(
                                                context, product);
                                          },
                                          icon: const Icon(
                                              Icons.more_vert_rounded),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            );
          }),
    );
  }

  //
  Future productBottomSheet(
    BuildContext context,
    ProductModel product,
  ) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //edit
                  ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProduct(product: product)));
                    },
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit'),
                  ),

                  // delete
                  ListTile(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete product'),
                          content:
                              const Text('Are you sure to delete product?'),
                          titlePadding:
                              const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          actionsPadding: const EdgeInsets.only(right: 10),
                          actions: [
                            //cancel
                            TextButton(
                                onPressed: () {
                                  //close
                                  Navigator.pop(context);

                                  //close bottom sheet
                                  Navigator.pop(context);
                                },
                                child: const Text(('Cancel'))),

                            // const SizedBox(width: 16),
                            // delete
                            OutlinedButton(
                                onPressed: () async {
                                  //removeFromProduct
                                  await ProductProviderAdmin.removeProduct(
                                      id: product.id);

                                  //removeProductImage
                                  for (var imageUrl in product.images) {
                                    ProductProviderAdmin.removeProductImage(
                                        imageUrl: imageUrl);
                                    //
                                  }

                                  //close
                                  Navigator.pop(context);
                                  //close
                                  Navigator.pop(context);
                                },
                                child: const Text(('Delete'))),
                          ],
                        ),
                      );
                    },
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                  ),
                ],
              ),
            ));
  }
}

//
class CategoryDetails extends StatelessWidget {
  const CategoryDetails({Key? key, required this.data}) : super(key: key);
  final DocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.get('name')),
      ),

      //
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('All Brand')
              .doc('Brand')
              .collection(data.get('name'))
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.docs;

            if (data.isEmpty) {
              return const Center(child: Text('No product found'));
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: snapshot.data!.docs
                      .map((item) => Card(
                            child: ListTile(
                              title: Text(item.get('name')),
                            ),
                          ))
                      .toList()),
            );
          }),
    );
  }
}
