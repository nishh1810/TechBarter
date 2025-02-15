class CartProduct {
  String? productId;
  String? name;
  double? price;
  int? cartQuantity;
  int? itemQuantity;
  /// manual
  double? total;

  CartProduct(
      {this.productId,
        this.name,
        this.price,
        this.cartQuantity,
        this.itemQuantity});

  CartProduct.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    price = json['price'];
    cartQuantity = json['cartQuantity'];
    itemQuantity = json['itemQuantity'];
    total = (price! * cartQuantity!) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['name'] = name;
    data['price'] = price;
    data['cartQuantity'] = cartQuantity;
    data['itemQuantity'] = itemQuantity;
    data['total'] = total;
    return data;
  }

  @override
  String toString() {
    return 'CartProduct(productId: $productId, name: $name, price: $price, cartQuantity: $cartQuantity, itemQuantity: $itemQuantity)';
  }

}