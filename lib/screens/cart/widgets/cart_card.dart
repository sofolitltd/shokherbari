import 'package:flutter/material.dart';

import '/models/product_model.dart';
import '/provider/cart_provider.dart';
import '/utils/constrains.dart';

//
class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.product,
    required this.quantity,
  }) : super(key: key);

  final ProductModel product;
  final int quantity;

  @override
  build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          //
          Row(
            children: [
              //image
              Container(
                height: 100,
                width: 100,
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
                  padding: const EdgeInsets.all(8),
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
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                        ),
                      ),

                      // sale price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // sale price x qty
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // sale price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // offer price
                                  Text(
                                    '$kTk ${product.salePrice}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.red),
                                  ),

                                  const SizedBox(width: 5),

                                  // x
                                  Text(
                                    'x',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),

                                  const SizedBox(width: 5),

                                  //qty
                                  Text(
                                    '$quantity',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),

                              //sub total
                              Row(
                                children: [
                                  Text(
                                    '$kTk ${product.salePrice * quantity}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // qty
                          Row(
                            children: [
                              // remove
                              GestureDetector(
                                onTap: () {
                                  //removeQuantity
                                  CartProvider.removeQuantity(
                                    id: product.id,
                                    quantity: quantity,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                  ),
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 22,
                                  ),
                                ),
                              ),

                              // qty text
                              Container(
                                constraints: const BoxConstraints(minWidth: 32),
                                alignment: Alignment.center,
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              //add qty
                              GestureDetector(
                                onTap: () {
                                  if (product.stockQuantity - quantity != 0) {
                                    CartProvider.addQuantity(
                                      id: product.id,
                                      quantity: quantity,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Not enough product in stock'),
                                        ),
                                      );
                                    // Fluttertoast.showToast(
                                    //     msg: 'Not enough products in stock');
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // remove from cart
          GestureDetector(
            onTap: () async {
              //removeFromCart
              CartProvider.removeFromCart(id: product.id);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
