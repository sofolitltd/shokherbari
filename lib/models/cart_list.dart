class CartList {
  final String productId;
  final int quantity;
  final int price;

  CartList({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  //fetch
  // CartProduct.fromJson(Map<String, Object?> json)
  //     : this(
  //         productId: json['productId']! as String,
  //         quantity: json['quantity']! as int,
  //       );

  //fetch
  static fromSnapshot(json) => CartList(
        productId: json['productId']! as String,
        quantity: json['quantity']! as int,
        price: json['price']! as int,
      );

  // upload
  Map<String, Object?> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
