import 'package:tech_barter/models/Order.dart';
import 'package:tech_barter/models/Product.dart';

class OrderResponse {
  OrderResponse({
    required this.order,
    required this.product,
    required this.customerName,
    required this.sellerName,
  });

  final Order order;
  final Product? product;
  final String? customerName;
  final String? sellerName;

  factory OrderResponse.fromJson(Map<String, dynamic> json){
    return OrderResponse(
      order: Order.fromJson(json["order"]),
      product: json["product"] == null ? null : Product.fromJson(json["product"]),
      customerName: json["customerName"],
      sellerName: json["sellerName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "order": order.toJson(),
    "product": product?.toJson(),
    "customerName": customerName,
    "sellerName": sellerName,
  };

  @override
  String toString(){
    return "$order, $product, $customerName, $sellerName, ";
  }
}