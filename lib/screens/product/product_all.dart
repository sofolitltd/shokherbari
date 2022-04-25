import 'package:flutter/material.dart';
import 'package:shokher_bari/screens/product/product_list.dart';

class ProductAll extends StatelessWidget {
  const ProductAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),

      //
      body: const ProductList(),
    );
  }
}
