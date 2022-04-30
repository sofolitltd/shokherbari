import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/admin/screens/subcategory/all_subcategory_admin.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '/admin/screens/category/add_category.dart';
import '../../provider_admin/category_provider.dart';

class AllCategoryAdmin extends StatelessWidget {
  const AllCategoryAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Category'),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCategory()));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: UserRepo.refCategories.snapshots(),
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

            return ListView.separated(
                itemCount: data.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  //
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Row(
                          children: [
                            //category image
                            Image.network(
                              data[index].get('image'),
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),

                            const SizedBox(width: 8),

                            //
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 8, 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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

                                    //
                                    Row(
                                      children: [
                                        // sub category btn
                                        Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                String category =
                                                    data[index].get('name');
                                                String categoryId =
                                                    data[index].id;

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AllSubcategoryAdmin(
                                                              category:
                                                                  category,
                                                              categoryId:
                                                                  categoryId,
                                                            )));
                                              },
                                              child:
                                                  const Text('Subcategories')),
                                        ),

                                        const SizedBox(width: 8),

                                        // remove category button
                                        IconButton(
                                          onPressed: () async {
                                            var id = data[index].id;
                                            var imageUrl =
                                                data[index].get('image');

                                            //removeFromCategory
                                            await CategoryProvider
                                                .removeFromCategory(id: id);

                                            //removeCategoryImage
                                            CategoryProvider
                                                .removeCategoryImage(
                                                    imageUrl: imageUrl);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
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
