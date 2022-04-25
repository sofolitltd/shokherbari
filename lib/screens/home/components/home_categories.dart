import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/utils/constrains.dart';

import 'home_categories_details.dart';

class HomeCategory extends StatelessWidget {
  const HomeCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child:
              Text('Categories', style: Theme.of(context).textTheme.headline6),
        ),

        // categories
        SizedBox(
          height: 250,
          child: StreamBuilder<QuerySnapshot>(
              stream: MyRepo.refCategories.orderBy('name').limit(4).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data!.docs;

                if (data.isEmpty) {
                  return const Center(child: Text("No category found"));
                }

                return GridView.builder(
                    itemCount: data.length,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.6,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        categoryCard(context, data, index));
              }),
        ),
      ],
    );
  }

  // category card
  Widget categoryCard(BuildContext context,
      List<QueryDocumentSnapshot<Object?>> data, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeCategoriesDetails(category: data[index])));
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          //image
          Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade200,
                image: DecorationImage(
                  image: NetworkImage(data[index].get('image')),
                  fit: BoxFit.cover,
                )),
          ),

          // name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            // margin: const EdgeInsets.only(bottom: 8, right: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(.8),
              // borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              '${data[index].get('name')}'.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    // letterSpacing: 1,
                  ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
