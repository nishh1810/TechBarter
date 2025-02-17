import 'package:tech_barter/models/RefType.dart';

class Items {
  String? productId;
  int? quantity;
  RefType? image;

  Items({this.productId, this.quantity});

  Items.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['quantity'] = quantity;
    return data;
  }

  @override
  String toString() {
    return 'Items(productId: $productId, quantity: $quantity)';
  }
}