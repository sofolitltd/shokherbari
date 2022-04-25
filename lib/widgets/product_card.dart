import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shokher_bari/models/product_model.dart';
import 'package:shokher_bari/provider/wishlist_provider.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '../provider/cart_provider.dart';
import '../screens/product/product_details.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);
  final ProductModel product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetails(product: widget.product)));
      },
      child: Container(
        width: width * .45,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1, 2),
                spreadRadius: 1,
                blurRadius: 5,
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  // image
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      minHeight: 150,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(widget.product.images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // add to favorite
                  StreamBuilder<DocumentSnapshot>(
                      stream:
                          MyRepo.refWishlist.doc(widget.product.id).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                            ),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.all(6),
                            child: snapshot.hasData
                                ? const Icon(Icons.favorite_border,
                                    color: Colors.red, size: 20)
                                : const Icon(
                                    Icons.favorite_border_rounded,
                                    size: 20,
                                  ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                            ),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.all(6),
                            child: snapshot.hasData
                                ? const Icon(Icons.favorite_border,
                                    color: Colors.red, size: 20)
                                : const Icon(
                                    Icons.favorite_border_rounded,
                                    size: 20,
                                  ),
                          );
                        }

                        if (snapshot.data!.exists) {
                          return GestureDetector(
                            onTap: () {
                              //removeFromWishList
                              WishlistProvider.removeFromWishList(
                                  id: widget.product.id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,
                              ),
                              padding: const EdgeInsets.all(6),
                              margin: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            //addToWishList
                            WishlistProvider.addToWishList(
                                product: widget.product);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                            ),
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.favorite_border_rounded,
                              size: 20,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),

            // text section
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //cat  sub
                  Row(
                    children: [
                      // category
                      Text(
                        widget.product.category,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.arrow_forward_ios_outlined, size: 10),
                      ),

                      // subcategory
                      Text(
                        widget.product.subcategory,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // name
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // weight
                  Text(
                    widget.product.weight,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // price and cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // sale $ regular price
                      Row(
                        children: [
                          // sale price
                          Text(
                            '$kTk ${widget.product.salePrice}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade500,
                            ),
                          ),

                          const SizedBox(width: 8),
                          // regular price
                          if (widget.product.regularPrice != 0)
                            Text(
                              ' $kTk${widget.product.regularPrice} ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),

                      // add to cart
                      if (widget.product.stockQuantity != 0)
                        StreamBuilder<DocumentSnapshot>(
                            stream: MyRepo.refCart
                                .doc(widget.product.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              //
                              if (snapshot.hasError) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: snapshot.hasData
                                      ? const Icon(Icons.shopping_cart,
                                          color: Colors.red)
                                      : const Icon(
                                          Icons.shopping_cart_outlined),
                                );
                              }

                              //
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: snapshot.hasData
                                      ? const Icon(Icons.shopping_cart,
                                          color: Colors.red)
                                      : const Icon(
                                          Icons.shopping_cart_outlined),
                                );
                              }

                              //
                              if (snapshot.data!.exists) {
                                return GestureDetector(
                                  onTap: () {
                                    //remove from cart
                                    CartProvider.removeFromCart(
                                        id: widget.product.id);
                                  },
                                  child: const Icon(Icons.shopping_cart,
                                      color: Colors.red),
                                );
                              }

                              return GestureDetector(
                                onTap: () async {
                                  //add to cart
                                  CartProvider.addToCart(
                                      product: widget.product);
                                },
                                child: const Icon(Icons.shopping_cart_outlined),
                              );
                            }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
