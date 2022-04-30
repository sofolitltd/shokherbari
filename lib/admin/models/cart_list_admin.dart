class CartList {
  final String productId;
  final String name;
  final String image;
  final int quantity;
  final int price;

  CartList({
    required this.productId,
    required this.name,
    required this.image,
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
        name: json['name']! as String,
        image: json['image']! as String,
        quantity: json['quantity']! as int,
        price: json['price']! as int,
      );

  // upload
  Map<String, Object?> toJson() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'quantity': quantity,
      'price': price,
    };
  }
}
