import 'dart:convert';

class ProductsModel {
  final List<Product> products;
  final int total;

  ProductsModel({
    required this.products,
    required this.total,
  });

  ProductsModel copyWith({
    List<Product>? products,
    int? total,
  }) =>
      ProductsModel(
        products: products ?? this.products,
        total: total ?? this.total,
      );

  factory ProductsModel.fromRawJson(String str) =>
      ProductsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  // factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
  //       products: List<Product>.from(
  //           json["products"].map((x) => Product.fromJson(x))),
  //       total: json["total"],
  //     );

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        products: json["products"] != null
            ? List<Product>.from(
                json["products"].map((x) => Product.fromJson(x)))
            : [],
        total: json["total"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "total": total,
      };
}

class Product {
  final String title;
  final String brand;
  final int price;
  final int id;
  final String imageUrl;
  final String rating;

  Product({
    required this.title,
    required this.brand,
    required this.price,
    required this.id,
    required this.imageUrl,
    required this.rating,
  });

  Product copyWith({
    String? title,
    String? brand,
    int? price,
    int? id,
    String? imageUrl,
    String? rating,
  }) =>
      Product(
        title: title ?? this.title,
        brand: brand ?? this.brand,
        price: price ?? this.price,
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        rating: rating ?? this.rating,
      );

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        title: json["title"],
        brand: json["brand"],
        price: json["price"],
        id: json["id"],
        imageUrl: json["image_url"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "brand": brand,
        "price": price,
        "id": id,
        "image_url": imageUrl,
        "rating": rating,
      };
}
