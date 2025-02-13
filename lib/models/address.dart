class Address {
  String? street;
  String? city;
  String? state;
  String? country;
  String? zipCode;

  Address({this.street, this.city, this.state, this.country, this.zipCode});

  Address.fromJson(Map<String, dynamic> json) {
    print("got json $json");
    street = json['street'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipCode'] = zipCode;
    return data;
  }
}