import 'package:tech_barter/models/RefType.dart';

class Order {
  String? id;
  RefType? customer;
  RefType? seller;
  RefType? product;
  int? soldQuantity;
  double? amount;
  double? taxAmount;
  double? totalAmount;
  String? status;
  RefType? paymentId;
  String? orderDate;
  String? deliveryDate;

  Order(
      {this.id,
        this.customer,
        this.seller,
        this.product,
        this.soldQuantity,
        this.amount,
        this.taxAmount,
        this.totalAmount,
        this.status,
        this.paymentId,
        this.orderDate,
        this.deliveryDate});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null
        ? RefType.fromJson(json['customer'])
        : null;
    seller =
    json['seller'] != null ? RefType.fromJson(json['seller']) : null;
    product =
    json['product'] != null ? RefType.fromJson(json['product']) : null;
    soldQuantity = json['soldQuantity'];
    amount = json['amount'];
    taxAmount = json['taxAmount'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    paymentId = json['paymentId'] != null
        ? RefType.fromJson(json['paymentId'])
        : null;
    orderDate = json['orderDate'];
    deliveryDate = json['deliveryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (seller != null) {
      data['seller'] = seller!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['soldQuantity'] = soldQuantity;
    data['amount'] = amount;
    data['taxAmount'] = taxAmount;
    data['totalAmount'] = totalAmount;
    data['status'] = status;
    if (paymentId != null) {
      data['paymentId'] = paymentId!.toJson();
    }
    data['orderDate'] = orderDate;
    data['deliveryDate'] = deliveryDate;
    return data;
  }
  @override
  String toString(){
    return "$id, $customer, $seller, $product, $soldQuantity, $amount, $taxAmount, $totalAmount, $status, $paymentId, $orderDate, $deliveryDate, ";
  }
}
