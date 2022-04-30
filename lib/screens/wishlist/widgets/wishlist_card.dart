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
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            //
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //image
                Container(
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100.withOpacity(.2),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(product.images[0]),
                    ),
                  ),
                ),

                // title , price
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // category, subcategory
                        Row(
                          children: [
                            // category
                            Text(
                              product.category,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 10,
                              ),
                            ),

                            // subcategory
                            Text(
                              product.subcategory,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),

                        //name
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          constraints: const BoxConstraints(
                            minHeight: 40,
                          ),
                          child: Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                          ),
                        ),

                        // sale price
                        Column(
                          children: [
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

                            // offer price
                            Text(
                              '$kTk ${product.salePrice}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

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
    );
  }
}
