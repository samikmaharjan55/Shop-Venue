import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_venue/helper/custom_route.dart';
import 'package:shop_venue/providers/auth_provider.dart';
import 'package:shop_venue/screens/auth_screen.dart';
import 'package:shop_venue/screens/order_screen.dart';
import 'package:shop_venue/screens/product_overview_screen.dart';
import 'package:shop_venue/screens/user_product_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isInit = true;
  String email = '';
  String userType = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      getUserData();
    }
    isInit = false;
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString("userData")!) as Map<String, Object>;
    setState(() {
      email = extractedData['email'].toString();
      userType = extractedData["userType"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Samik Maharjan'),
            accountEmail: Text(email),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/52682120?v=4'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ProductOverviewScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              //Navigator.pushReplacementNamed(context, OrderScreen.routeName);
              Navigator.of(context).pushReplacement(CustomRoute(
                  builder: (ctx) => const OrderScreen(),
                  settings: const RouteSettings()));
            },
          ),
          const Divider(),
          userType == "client"
              ? Container()
              : Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Manage Products'),
                      onTap: () {
                        Navigator.of(context).pushReplacement(CustomRoute(
                            builder: (ctx) => const UserProductScreen(),
                            settings: const RouteSettings()));
                      },
                    ),
                    const Divider(),
                  ],
                ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.of(context).pop();

              await Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
