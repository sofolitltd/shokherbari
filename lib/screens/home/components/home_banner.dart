import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/utils/constrains.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: FutureBuilder<QuerySnapshot>(
        future: MyRepo.refBanner.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return Container(
              height: 200,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  'Welcome To Shokher Bari',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            );
          }

          return Carousel(
            dotPosition: DotPosition.bottomLeft,
            dotIncreasedColor: Colors.red,
            dotBgColor: Colors.transparent,
            // borderRadius: true,
            autoplayDuration: const Duration(seconds: 10),
            animationDuration: const Duration(milliseconds: 500),
            images: data
                .map(
                  (image) => CachedNetworkImage(
                    imageUrl: image.get('image'),
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, value) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
