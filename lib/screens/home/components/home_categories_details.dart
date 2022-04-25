import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/screens/home/components/home_subcategories.dart';

class HomeCategoriesDetails extends StatelessWidget {
  const HomeCategoriesDetails({Key? key, required this.category})
      : super(key: key);
  final QueryDocumentSnapshot category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.get('name')),
      ),

      //
      body: HomeSubcategories(category: category),
    );
  }
}
