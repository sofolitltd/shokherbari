import 'package:flutter/material.dart';

import '/models/product_model.dart';
import '/provider/wishlist_provider.dart';
import '/screens/product/product_details.dart';
import '/utils/constrains.dart';

class WishlistCard extends StatelessWidget {
  const WishlistCard({Key? key, required this.product}) : super(key: key);
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetails(product: product)));
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //image
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                color: Colors.pink.shade100.withOpacity(.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(product.images[0]),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // title , price
            Expanded(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  //
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //brand
                          Text(
                            product.subcategory,
                            style: const TextStyle(color: Colors.grey),
                          ),

                          //name
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              product.name,
                              maxLines: 2,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // sale price
                      Row(
                        children: [
                          // offer price
                          Text(
                            '$kTk ${product.salePrice}',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),

                          const SizedBox(width: 8),

                          // regular price
                          if (product.regularPrice != 0)
                            Text(
                              '$kTk ${product.regularPrice}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                            ),
                        ],
                      ),
                    ],
                  ),

                  //
                  // delete
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: () async {
                        //removeFromWishList
                        WishlistProvider.removeFromWishList(id: product.id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(4),
                        child: const Icon(Icons.delete_outline, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
