import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/utils/constrains.dart';
import '../../product/product_list.dart';
import 'home_subcategories_details.dart';

class HomeSubcategories extends StatefulWidget {
  const HomeSubcategories({Key? key, required this.category}) : super(key: key);
  final QueryDocumentSnapshot category;

  @override
  State<HomeSubcategories> createState() => _HomeSubcategoriesState();
}

class _HomeSubcategoriesState extends State<HomeSubcategories> {
  String selectedShortBy = 'All';

  @override
  Widget build(BuildContext context) {
    print(widget.category);
    return ListView(
      children: [
        // title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text('Sub Categories',
              style: Theme.of(context).textTheme.headline6),
        ),

        // sub categories
        SizedBox(
          height: 120,
          child: StreamBuilder<QuerySnapshot>(
              stream: MyRepo.refSubcategories
                  .where('category', isEqualTo: widget.category.get('name'))
                  .orderBy('name', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                print(snapshot.error);

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data!.docs;

                if (data.isEmpty) {
                  return const Center(child: Text("No subcategory found"));
                }

                //
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  itemBuilder: (context, index) => subCategoryCard(
                      context, data, index, widget.category.get('name')),
                );
              }),
        ),

        // const Divider(),

        Container(
          height: 48,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // short by title
              Text('Short By'.toUpperCase()),

              //short by dropdown
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedShortBy,
                      items: MyRepo.shortByList
                          .map((String val) => DropdownMenuItem<String>(
                                child: Text(val),
                                value: val,
                              ))
                          .toList(),
                      onChanged: (String? val) {
                        setState(() {
                          selectedShortBy = val!;
                        });
                      }),
                ),
              ),
            ],
          ),
        ),

        //
        ProductList(
            category: widget.category.get('name'), shortBy: selectedShortBy),
      ],
    );
  }

  //sub categoryCard
  GestureDetector subCategoryCard(BuildContext context,
      List<QueryDocumentSnapshot<Object?>> data, int index, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeSubcategoriesDetails(
                    category: category, subcategory: data[index])));
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //category image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(2, 2))
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      data[index].get('image'),
                    ),
                  ),
                ),
              ),
            ),
            //

            const SizedBox(height: 8),

            //category name
            FittedBox(
              child: Text(
                '${data[index].get('name')}'.toUpperCase(),
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        // color: Colors.yellow,
        margin: const EdgeInsets.only(right: 4),
      ),
    );
  }
}
