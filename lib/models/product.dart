import 'dart:convert';

import 'package:amazon_clone/models/rating.dart';

class Product {
  final String name;
  final String description;
  final double quantity;
  final List<String> images;
  final String category;
  final double price;
  final String? id;
  final List<Rating>? rating;

  Product(
      {this.id,
      required this.name,
      required this.description,
      required this.quantity,
      required this.images,
      required this.category,
      required this.price,
      this.rating});

  // convert in map
  Map<String, dynamic> toMap() {
    // print('i am in to map()');

    return {
      'product_name': name,
      'product_description': description,
      'product_quantity': quantity,
      'product_images': images,
      'product_category': category,
      'product_price': price,
      '_id': id,
      'rating': rating
    };
  }

  //from map to object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        description: map['product_description'] ?? '',
        images: List<String>.from(map['product_images']),
        name: map['product_name'] ?? '',
        price: map['product_price']?.toDouble() ?? 0.0,
        quantity: map['product_quantity']?.toDouble() ?? 0.0,
        category: map['product_category'] ?? '',
        id: map['_id'],
        rating: map['ratings'] != null
            ? List<Rating>.from(
                map['ratings']?.map(
                  (x) => Rating.fromMap(x),
                ),
              )
            : null);
  }

  // from object to json
  String toJson() {
    // print('i am in tojson');
    return json.encode(toMap());
  }

// from json to map to object
  factory Product.fromJson(String source) {
    return Product.fromMap(json.decode(source));
  }

  // rating
}
