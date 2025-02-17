import 'package:tech_barter/models/RefType.dart';

class CartProduct {
  String? productId;
  String? name;
  double? price;
  int? cartQuantity;
  int? itemQuantity;
  RefType? image;
  /// manual
  double? total;

  CartProduct(
      {this.productId,
        this.name,
        this.price,
        this.cartQuantity,
        this.itemQuantity,
        this.image,
      });

  CartProduct.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    price = json['price'];
    cartQuantity = json['cartQuantity'];
    itemQuantity = json['itemQuantity'];
    image = RefType.fromJson(json['image']);
    total = (price! * cartQuantity!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['name'] = name;
    data['price'] = price;
    data['cartQuantity'] = cartQuantity;
    data['itemQuantity'] = itemQuantity;
    data['image'] = image?.toJson();
    data['total'] = total;
    return data;
  }

  @override
  String toString() {
    return 'CartProduct(productId: $productId, name: $name, price: $price, cartQuantity: $cartQuantity, itemQuantity: $itemQuantity, image: $image, total: $total)';
  }

}