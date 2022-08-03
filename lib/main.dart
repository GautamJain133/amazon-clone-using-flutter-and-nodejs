import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes.dart';
import 'common/widgets/bottombar.dart';
import 'features/auth/services/auth_service.dart';
import 'provider/user_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    authService.getUser(context);

    //print('after getting user in initstate');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon_Clone',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),

      // yha pr ham type check kar rhe hai agar user admin hai to sdmin features bhi available honge or agar user customer hai to customer features available honge

      home: (Provider.of<UserProvider>(context).user.token.isNotEmpty)
          ? Provider.of<UserProvider>(context).user.type == 'user'
              ? const BottomBar()
              : const AdminScreen()
          : const AuthScreen(),
      onGenerateRoute: (settings) {
        return generateRoute(settings);
      },
    );
  }
}
