import 'package:tech_barter/models/RefType.dart';

import 'address.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? username;
  List<Roles>? roles;
  RefType? profileImage;
  Address? address;

  User({this.id, this.name, this.email, this.username, this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
    profileImage = json['profileImage'] != null
        ? RefType.fromJson(json['profileImage'])
        : null;
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['username'] = username;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    if (profileImage != null) {
      data['profileImage'] = profileImage!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}



class Roles {
  String? id;
  String? name;

  Roles({this.id, this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}