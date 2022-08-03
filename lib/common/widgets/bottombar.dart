import 'package:amazon_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone/features/account/screens/account_screen.dart';
import 'package:badges/badges.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:provider/provider.dart';
import '../../features/home/screens/home_screen.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actualHome';

  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  int page = 0;
  double bottomBarWidth = 42;
  double bottomBarborderwidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen()
  ];

  void updatePage(int ppage) {
    setState(
      () {
        page = ppage;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;
    return Builder(builder: (context) {
      return Scaffold(
        body: pages[page],
        bottomNavigationBar: Builder(builder: (context) {
          return BottomNavigationBar(
            currentIndex: page,
            selectedItemColor: GlobalVariables.selectedNavBarColor,
            unselectedItemColor: GlobalVariables.unselectedNavBarColor,
            backgroundColor: GlobalVariables.backgroundColor,
            iconSize: 28,
            onTap: updatePage,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: page == 0
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: bottomBarborderwidth,
                      ),
                    ),
                  ),
                  child: const Icon(Icons.home_outlined),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: page == 1
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: bottomBarborderwidth,
                      ),
                    ),
                  ),
                  child: const Icon(Icons.person_outlined),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: page == 2
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: bottomBarborderwidth,
                      ),
                    ),
                  ),
                  child: Badge(
                      elevation: 0,
                      badgeContent: Text(userCartLen.toString()),
                      badgeColor: Colors.white,
                      child: const Icon(Icons.shopping_cart_outlined)),
                ),
                label: '',
              ),
            ],
          );
        }),
      );
    });
  }
}
