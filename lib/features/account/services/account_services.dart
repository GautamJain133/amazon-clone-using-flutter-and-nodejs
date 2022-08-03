import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../models/orders.dart';

class AccountServices {
  Future<List<Order>> getOrders({required BuildContext context}) async {
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/your-orders'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':
            Provider.of<UserProvider>(context, listen: false).user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSucess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnakeBar(context, e.toString());
    }

    print(orderList);
    return orderList;
  }
}
