import 'dart:convert';

import 'package:amazon_clone/constants/global_variables.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/bottombar.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/user_provider.dart';

class AuthService {
//----------------------------------------------------------------------------------------------------------------------------------------------------------
// sending the signup request on the server
  void signupUser({
    required BuildContext
        context, // context snackbar show krne k liye llaye hai
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // model the User data into the user object
      User user = User(
          address: "",
          id: "",
          email: email,
          name: name,
          password: password,
          token: "",
          type: "user",
          cart: []);

      // sending the post request to the server for signup
      http.Response res = await http.post(Uri.parse("$uri/api/signup"),

          // convert the user object into json for sending it on the server
          body: user.toJson(),

          // request header
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      // error handling part
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            showSnakeBar(context,
                'Account created successfully:Login with the same credentials');
          });
    } catch (e) {
      // print(e.toString());
      showSnakeBar(context, e.toString());
    }
  }

//-------------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------------
//signin user

  void signinUser({
    required BuildContext context,
    required String email, // getting the user data in parameters
    required String password,
  }) async {
    try {
      // sending the post request for signin

      http.Response res = await http.post(Uri.parse("$uri/api/signin"),

          // encode the data into json signup me hamne hamare function k through encode kiya tha yha direct kar rhe hai
          body: jsonEncode({'useremail': email, 'userpassword': password}),

          // header
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      // error handling part
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () async {
            // if no error occur server send the data along with the token

            // we took the acces for the app level memory
            SharedPreferences prefs = await SharedPreferences.getInstance();

            // ignore: use_build_context_synchronously
            Provider.of<UserProvider>(context, listen: false)
                .setUser(res.body); // set the user data

            // now save the token on the app level memory
            prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

            // push user on the bottombar scren(main screen)
            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, (route) => false);
          });
    } catch (e) {
      // print(e.toString());
      showSnakeBar(context, e.toString());
    }
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  // as the user click on the app we apply for the get user data
  void getUser(BuildContext context) async {
    try {
      // first we took the instance of the app level memory
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // get our saved token
      String? token = prefs.getString('x-auth-token');

      // agar user first bar login kar rha hai to hamare pass token nhi hoga
      // or agar token null hai to ham token ko shared preferences me empty set kar denge or
      // auth screen user ko dikha denge
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      // ab ham check krege token valid hai ya nhi agr valid hai to
      // home screen par redirect kar denge or agar valid nhi hai to auth screen par redirect kardenge

      // chack karne k  liye ham api bna rhe hai kyuki hamare taki ham shared prefences k token to hamare databse wale tokens k
      // sath match krwa kr dekh sake ham ye api auth.js on server wali file me bna bne hai by by

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      // ab agr hamara token valid hoga to hamko response me true milega
      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        // ab agar response me true milta hai to ham user ka data utha lenge hamare server(databse) se
        // bina signin krwaye or uske liye ham ek api bna rhe hai auth.js me
        // and there we once angain verify the token

        // ab ham us get api ka use karke user ka data lenge
        // print('hello brother token is $token');

        http.Response userRes = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });

        // ignore: use_build_context_synchronously
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      // print('error');
      Scaffold(body: Center(child: Text(e.toString())));
    }
  }
}
