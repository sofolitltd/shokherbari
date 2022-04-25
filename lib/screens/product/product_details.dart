import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/models/product_model.dart';
import 'package:shokher_bari/provider/cart_provider.dart';
import 'package:shokher_bari/provider/wishlist_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '/utils/constrains.dart';
import '../cart/cart.dart';
import '../home/home.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.product}) : super(key: key);
  final ProductModel product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: .1,
        title: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (_) => const Home()),
            );
          },
          child: const Text(kBrandName),
        ),
        actions: [
          // cart
          Stack(
            alignment: Alignment.topRight,
            children: [
              //cart
              IconButton(
                  onPressed: () {
                    // go to cart
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const Cart()));
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 25,
                  )),

              // badge
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: .3,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: MyRepo.refCart.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }

                        // counter
                        String cartCounter = snapshot.data!.size.toString();
                        print('cart: ' + cartCounter);
                        return Text(
                          cartCounter,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),

      //
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56),
        child: FloatingActionButton(
          onPressed: () async {
            //
            final Uri launchUri = Uri(
              scheme: 'tel',
              path: '01704340860',
            );
            await launchUrl(launchUri);
          },
          child: const Icon(
            Icons.support_agent,
            size: 32,
          ),
        ),
      ),

      //
      body: Column(
        children: [
          //
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                // product image
                SizedBox(
                  height: 260,
                  child: Carousel(
                    boxFit: BoxFit.cover,
                    autoplay: false,
                    dotIncreasedColor: Colors.red,
                    dotBgColor: Colors.transparent,
                    indicatorBgPadding: 10,
                    // dotPosition: DotPosition.bottomCenter,
                    // dotIncreaseSize: 4,
                    images: widget.product.images
                        .map((image) => Image.network(
                              image,
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 8),

                // product info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name & price
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      color: Colors.white,
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
                                child: Icon(Icons.arrow_forward_ios_outlined,
                                    size: 10),
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

                          const SizedBox(height: 4),

                          //name
                          Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),

                          const SizedBox(height: 8),

                          // price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //offer price
                                  Text(
                                    '$kTk ${widget.product.salePrice}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),

                                  const SizedBox(width: 8),

                                  // regular price
                                  if (widget.product.regularPrice != 0)
                                    Text(
                                      '$kTk ${widget.product.regularPrice}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                    ),
                                ],
                              ),

                              // share & favorite
                              Row(
                                children: [
                                  // share
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.share_outlined,
                                      size: 20,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // add to favorite
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: MyRepo.refWishlist
                                          .doc(widget.product.id)
                                          .snapshots(),
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
                                                ? const Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.red,
                                                    size: 20)
                                                : const Icon(
                                                    Icons
                                                        .favorite_border_rounded,
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
                                                ? const Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.red,
                                                    size: 20)
                                                : const Icon(
                                                    Icons
                                                        .favorite_border_rounded,
                                                    size: 20,
                                                  ),
                                          );
                                        }

                                        if (snapshot.data!.exists) {
                                          return GestureDetector(
                                            onTap: () {
                                              //removeFromWishList
                                              WishlistProvider
                                                  .removeFromWishList(
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
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // product description
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      constraints: const BoxConstraints(
                        minHeight: 150,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title
                          Text('Product Description',
                              style: Theme.of(context).textTheme.subtitle2),

                          const SizedBox(height: 4),

                          //description
                          Text(widget.product.description,
                              style: Theme.of(context).textTheme.bodyText2!
                              // .copyWith(color: Colors.grey),
                              )
                        ],
                      ),
                    ),
                  ],
                ),

                // similar product
                // const FeaturedProductHome(),
              ],
            ),
          ),

          // buy / cart
          widget.product.stockQuantity != 0
              ? Container(
                  margin: const EdgeInsets.only(
                      // vertical: 12,
                      // horizontal: 16,
                      ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      // buy now
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                            ),
                            onPressed: () async {
                              // first => add to cart
                              CartProvider.addToCart(product: widget.product);

                              // then go to cart
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Cart()));
                            },
                            child: const Text('Buy Now'),
                          ),
                        ),
                      ),

                      // const SizedBox(width: 8),

                      // add to cart
                      Expanded(
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: MyRepo.refCart
                                .doc(widget.product.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              // if (snapshot.hasError) {
                              //   //
                              //   return IconButton(
                              //     onPressed: () {},
                              //     icon: snapshot.hasData
                              //         ? const Icon(Icons.shopping_cart,
                              //             color: Colors.red)
                              //         : const Icon(Icons.shopping_cart_outlined),
                              //   );
                              // }

                              //
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 50,
                                  child: CupertinoActivityIndicator(),
                                );
                              }

                              //
                              if (snapshot.data!.exists) {
                                return SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero),
                                    ),
                                    onPressed: () {
                                      //remove from cart
                                      CartProvider.removeFromCart(
                                          id: widget.product.id);
                                    },
                                    child: const Text('Remove From Cart'),
                                  ),
                                );
                              }

                              // add to cart
                              return SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                  ),
                                  onPressed: () async {
                                    //add to cart
                                    CartProvider.addToCart(
                                        product: widget.product);
                                  },
                                  child: const Text('Add To Cart'),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: const Text(
                    'Out of Stock',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }
}
