import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/admin/admin.dart';
import '/utils/constrains.dart';
import '../search/search _product.dart';
import 'components/home_all_product.dart';
import 'components/home_banner.dart';
import 'components/home_categories.dart';
import 'components/home_featured_product.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: false,
        title: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          alignment: Alignment.centerLeft,
          children: [
            //logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.asset(
                'assets/logo/logo.png',
                color: Colors.white,
                // height: 56,
                width: 56,
              ),
            ),

            //app name
            const Padding(
              padding: EdgeInsets.only(left: 40, top: 8),
              child: Text(kBrandName),
            ),
          ],
        ),
        // leading: MyRepo.userEmail == 'asifreyad2@gmail.com'
        leading: StreamBuilder<DocumentSnapshot>(
            stream: MyRepo.ref
                .collection('Admin')
                .doc(MyRepo.userEmail)
                // .doc('ashanulhaque008@gmail.com')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                return IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Admin()));
                    },
                    icon: const Icon(Icons.menu));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Container();
            }),
        actions: [
          // search
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SearchPage()));
              },
              icon: const Icon(Icons.search_outlined)),
        ],
      ),

      //
      body: ListView(
        shrinkWrap: true,
        children: const [
          // banner
          HomeBanner(),

          // category
          HomeCategory(),

          // AllProductsHome
          FeaturedProductHome(),

          //AllProductsHome
          AllProductHome(),
        ],
      ),
    );
  }
}
