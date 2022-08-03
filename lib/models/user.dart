import 'dart:convert';

class User {
  final String id;
  final String email;
  final String name;
  final String password;
  final String address;
  final String type;
  final String token;
  final List<dynamic> cart;

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.email,
    required this.cart,
  });

  // convert in map
  Map<String, dynamic> toMap() {
    // print('i am in to map()');

    return {
      '_id': id,
      'username': name,
      'useremail': email,
      'userpassword': password,
      'useraddress': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  //from map to object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['username'] ?? '',
      password: map['userpassword'] ?? '',
      address: map['useraddress'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      email: map['useremail'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map((x) => Map<String, dynamic>.from(x)),
      ),
    );
  }

  // from object to json
  String toJson() {
    // print('i am in tojson');
    return json.encode(toMap());
  }

// from json to map to object
  factory User.fromJson(String source) {
    return User.fromMap(json.decode(source));
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
