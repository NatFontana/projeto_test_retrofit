class UserModel {
  UserModel({
    String? createdAt,
    String? name,
    String? avatar,
    String? id,
  }) {
    _createdAt = createdAt;
    _name = name;
    _avatar = avatar;
    _id = id;
  }

  UserModel.fromJson(dynamic json) {
    _createdAt = json['createdAt'];
    _name = json['name'];
    _avatar = json['avatar'];
    _id = json['id'];
  }

  String? _createdAt;
  String? _name;
  String? _avatar;
  String? _id;

  String? get createdAt => _createdAt ?? '';

  String? get name => _name ?? '';

  String? get avatar => _avatar ?? '';

  String? get id => _id ?? '';

  get options => null;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdAt'] = _createdAt;
    map['name'] = _name;
    map['avatar'] = _avatar;
    map['id'] = _id;
    return map;
  }
}
