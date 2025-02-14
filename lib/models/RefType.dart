import 'package:tech_barter/models/object_id.dart';

class RefType {
  String? id;
  String? sRef;

  RefType({this.id, this.sRef});

  RefType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sRef = json['_ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['_id'] = id;
    }
    data['_ref'] = sRef;
    return data;
  }
}