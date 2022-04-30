import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/utils/constrains.dart';
import '../../provider_admin/subcategory_provider.dart';
import 'add_subcategory.dart';

class AllSubcategoryAdmin extends StatelessWidget {
  const AllSubcategoryAdmin(
      {Key? key, required this.category, required this.categoryId})
      : super(key: key);
  final String category;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddSubcategory(
                        category: category,
                        categoryId: categoryId,
                      )));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: UserRepo.refSubcategories
              .where('category', isEqualTo: category)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.docs;

            if (data.isEmpty) {
              return const Center(child: Text('No subcategory found'));
            }

            return ListView.separated(
                itemCount: data.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        child: Row(
                          children: [
                            //subcategory image
                            Image.network(
                              data[index].get('image'),
                              fit: BoxFit.cover,
                              height: 72,
                              width: 100,
                            ),

                            const SizedBox(width: 12),

                            //
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 8, 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //category name
                                    Text(
                                      data[index].get('name'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),

                                    // delete image
                                    IconButton(
                                      onPressed: () async {
                                        String subcategoryId = data[index].id;
                                        String imageUrl =
                                            data[index].get('image');

                                        //removeFromSubcategory
                                        await SubcategoryProvider
                                            .removeFromSubcategory(
                                                subcategoryId: subcategoryId);

                                        //removeSubcategoryImage
                                        SubcategoryProvider
                                            .removeSubcategoryImage(
                                                imageUrl: imageUrl);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 4));
          }),
    );
  }
}
