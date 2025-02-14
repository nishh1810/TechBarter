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
      data['id'] = id;
    }
    data['_ref'] = sRef;
    return data;
  }

  @override
  String toString() {
    return 'RefType(id: $id, sRef: $sRef)';
  }

}