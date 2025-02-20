import 'package:tech_barter/models/RefType.dart';

class Review {
  String? id;
  RefType? user;
  RefType? product;
  String? comment;
  double? rating;
  String? timestamp;

  Review(
      {this.id,
        this.user,
        this.product,
        this.comment,
        this.rating,
        this.timestamp});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? RefType.fromJson(json['user']) : null;
    product =
    json['product'] != null ? RefType.fromJson(json['product']) : null;
    comment = json['comment'];
    rating = json['rating'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['comment'] = comment;
    data['rating'] = rating;
    data['timestamp'] = timestamp;
    return data;
  }

  @override
  String toString() {
    return 'Review{id: $id, user: $user, product: $product, comment: $comment, rating: $rating, timestamp: $timestamp}';
  }
}
