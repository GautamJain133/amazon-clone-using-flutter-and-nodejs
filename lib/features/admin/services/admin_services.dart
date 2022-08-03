import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/orders.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../models/product.dart';

import 'package:http/http.dart' as http;

import '../../../provider/user_provider.dart';
import '../model/sales.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context, // to display the errors
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dszlcwinr', 'dsrcw44y');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));

        imageUrls.add(res.secureUrl);
      }
      Product product = Product(
          category: category,
          description: description,
          name: name,
          price: price,
          quantity: quantity,
          images: imageUrls);

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: <String, String>{
          'content-Type': 'application/json; charset=UTF-8',
          // ignore: use_build_context_synchronously
          'x-auth-token':
              // ignore: use_build_context_synchronously
              Provider.of<UserProvider>(context, listen: false).user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
          context: context,
          response: res,
          onSucess: () {
            showSnakeBar(context, 'Product Added succesfully');

            Navigator.pop(context);
          });
    } catch (e) {
      showSnakeBar(context, e.toString());
    }
  }

  // get all pproducts
  // yha pr ham pehle ki tarah alg model nhi bna rhe product k liye balki pehle se hi hamre pass ek model hai jisko hamne use kiya tha product server pr send karne k liye ussse hi ham use krege

  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    List<Product> productList = [];

    try {
      http.Response productResponse = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: <String, String>{
          'content-Type': 'application/json; charset=UTF-8',
          // ignore: use_build_context_synchronously
          'x-auth-token':
              // ignore: use_build_context_synchronously
              Provider.of<UserProvider>(context, listen: false).user.token,
        },
      );

      httpErrorHandle(
        response: productResponse,
        context: context,
        onSucess: () {
          for (int i = 0; i < jsonDecode(productResponse.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(productResponse.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnakeBar(context, e.toString());
    }

    return productList;
  }

// function to delete the product

  void deleteProduct(
      {required BuildContext context,
      required Product product,
      required VoidCallback onSucess}) async {
    try {
      http.Response res = await http.post(
          Uri.parse('$uri/admin/delete-product'),
          headers: <String, String>{
            'content-Type': 'application/json; charset=UTF-8',
            // ignore: use_build_context_synchronously
            'x-auth-token':
                // ignore: use_build_context_synchronously
                Provider.of<UserProvider>(context, listen: false).user.token,
          },
          body: jsonEncode({'id': product.id}));

      httpErrorHandle(
          context: context,
          response: res,
          onSucess: () {
            onSucess();
          });
    } catch (e) {
      showSnakeBar(context, e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    List<Order> orderList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: <String, String>{
          'content-Type': 'application/json; charset=UTF-8',
          // ignore: use_build_context_synchronously
          'x-auth-token':
              // ignore: use_build_context_synchronously
              Provider.of<UserProvider>(context, listen: false).user.token,
        },
      );

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

    return orderList;
  }

  void changeOrderStatus(
      {required BuildContext context,
      required Order order,
      required VoidCallback onSucess,
      required int status}) async {
    try {
      http.Response res = await http.post(
          Uri.parse('$uri/admin/change-order-status'),
          headers: <String, String>{
            'content-Type': 'application/json; charset=UTF-8',
            // ignore: use_build_context_synchronously
            'x-auth-token':
                // ignore: use_build_context_synchronously
                Provider.of<UserProvider>(context, listen: false).user.token,
          },
          body: jsonEncode({'id': order.id, 'status': status}));

      httpErrorHandle(
          context: context,
          response: res,
          onSucess: () {
            onSucess();
          });
    } catch (e) {
      showSnakeBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSucess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          print(totalEarning);
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialsEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      print('hey');
      showSnakeBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}
