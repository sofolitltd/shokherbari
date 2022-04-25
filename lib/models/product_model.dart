import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String category;
  final String subcategory;
  final String id;
  final String name;
  final String description;
  final String weight;
  final int regularPrice;
  final int salePrice;
  final int stockQuantity;
  final bool featured;
  final List<dynamic> images;
  final String searchKey;

  //ratingCount

  ProductModel({
    required this.category,
    required this.subcategory,
    required this.id,
    required this.name,
    required this.description,
    required this.weight,
    required this.regularPrice,
    required this.salePrice,
    required this.stockQuantity,
    required this.featured,
    required this.images,
    required this.searchKey,
  });

  // upload
  Map<String, dynamic> toJson() => {
        'category': category,
        'subcategory': subcategory,
        'id': id,
        'name': name,
        'description': description,
        'weight': weight,
        'regularPrice': regularPrice,
        'salePrice': salePrice,
        'stockQuantity': stockQuantity,
        'featured': featured,
        'images': images,
        'searchKey': searchKey,
      };

  // download
  static fromSnapshot(DocumentSnapshot<Object?> json) => ProductModel(
        category: json['category']! as String,
        subcategory: json['subcategory']! as String,
        id: json['id']! as String,
        name: json['name']! as String,
        description: json['description']! as String,
        weight: json['weight']! as String,
        regularPrice: json['regularPrice']! as int,
        salePrice: json['salePrice']! as int,
        stockQuantity: json['stockQuantity']! as int,
        featured: json['featured']! as bool,
        images: json['images']! as List<dynamic>,
        searchKey: json['searchKey']! as String,
      );

// ProductModel.fromJson(Map<String, dynamic> json)
//     : this(
//         category: json['category']! as String,
//         subcategory: json['subcategory']! as String,
//         id: json['id']! as String,
//         name: json['name']! as String,
//         description: json['description']! as String,
//         weight: json['weight']! as String,
//         regularPrice: json['regular_price']! as int,
//         salePrice: json['sale_price']! as int,
//         stockQuantity: json['stockQuantity']! as int,
//         featured: json['featured']! as bool,
//         images: json['images']! as List<dynamic>,
//       );
}
