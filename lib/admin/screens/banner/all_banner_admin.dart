import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '/admin/provider_admin/banner_provider.dart';
import 'add_banner.dart';

class AllBannerAdmin extends StatelessWidget {
  const AllBannerAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Banner'),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBanner()));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: MyRepo.refBanner.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.docs;

            if (data.isEmpty) {
              return const Center(child: Text('No banner found'));
            }

            return ListView.separated(
              itemCount: data.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) {
                //
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .24,
                    constraints: const BoxConstraints(
                      minHeight: 150,
                    ),
                    child: GridTile(
                      child: Image.network(
                        data[index].get('image'),
                        fit: BoxFit.cover,
                      ),

                      // banner title, edit, delete
                      footer: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.7),
                        ),
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //title
                            Text(
                              data[index].get('name'),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),

                            //delete
                            Material(
                              color: Colors.transparent,
                              child: IconButton(
                                onPressed: () async {
                                  var id = data[index].id;
                                  var imageUrl = data[index].get('image');

                                  // removeBannerImage
                                  await BannerProvider.removeBannerImage(
                                      imageUrl: imageUrl);
                                  //removeBanner
                                  await BannerProvider.removeBanner(id: id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 8),
            );
          }),
    );
  }
}
