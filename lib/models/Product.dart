import 'package:tech_barter/models/RefType.dart';

class Product {
  String? id;
  String? name;
  String? description;
  double? price;
  int? quantity;
  bool? active;
  bool? isRecyclable;
  int? totalReview;
  double? avgRating;
  RefType? category;
  RefType? seller;
  List<RefType>? images;

  Product(
      {this.id,
        this.name,
        this.description,
        this.price,
        this.quantity,
        this.isRecyclable,
        this.active,
        this.totalReview,
        this.avgRating,
        this.category,
        this.seller,
        this.images
      });

  Product.fromJson(Map<String, dynamic> json) {
    // print("Product.fromJson: $json");
    try {
      id = json['id'];
      name = json['name'];
      description = json['description'];
      price = json['price'];
      quantity = json['quantity'];
      isRecyclable = json['recyclable'];
      active = json['active'];
      totalReview = json['totalReview'];
      avgRating = json['avgRating'];
      category = json['category'] != null ? RefType.fromJson(json['category']) : null;
      seller = json['seller'] != null ? RefType.fromJson(json['seller']) : null;
      images = json["images"] != null ? List<RefType>.from(json["images"]!.map((x) => RefType.fromJson(x))) : null;
    } catch (e) {
      print("Error in Product.fromJson: $e");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['quantity'] = quantity;
    data['recyclable'] = isRecyclable;
    data['active'] = active;
    data['totalReview'] = totalReview;
    data['avgRating'] = avgRating;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (seller != null) {
      data['seller'] = seller!.toJson();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, quantity: $quantity, isRecyclable: $isRecyclable, active: $active, totalReview: $totalReview, avgRating: $avgRating, category: $category, seller: $seller, images: $images)';
  }
}
