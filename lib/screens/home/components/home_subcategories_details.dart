import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/screens/product/product_list.dart';

import '/utils/constrains.dart';

class HomeSubcategoriesDetails extends StatefulWidget {
  const HomeSubcategoriesDetails(
      {Key? key, required this.category, required this.subcategory})
      : super(key: key);
  final String category;
  final QueryDocumentSnapshot subcategory;

  @override
  State<HomeSubcategoriesDetails> createState() =>
      _HomeSubcategoriesDetailsState();
}

class _HomeSubcategoriesDetailsState extends State<HomeSubcategoriesDetails> {
  String selectedShortBy = 'All';

  @override
  Widget build(BuildContext context) {
    print(widget.subcategory);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category + ' > ' + widget.subcategory.get('name')),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
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
                          items: shortByList
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
            Expanded(
                child: SingleChildScrollView(
              child: ProductList(
                  category: widget.category,
                  subcategory: widget.subcategory.get('name'),
                  shortBy: selectedShortBy),
            )),
          ],
        ),
      ),
    );
  }
}
