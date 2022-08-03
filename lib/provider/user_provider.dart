import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    password: '',
    address: '',
    type: '',
    token: '',
    email: '',
    cart: [],
  );

  User get user => _user;

  void setUser(String uuser) {
    _user = User.fromJson(uuser);

    // print('after set ${user.token}');
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
