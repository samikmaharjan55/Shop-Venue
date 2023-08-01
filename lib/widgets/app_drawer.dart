import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/helper/custom_route.dart';
import 'package:shop_venue/providers/auth_provider.dart';
import 'package:shop_venue/screens/auth_screen.dart';
import 'package:shop_venue/screens/order_screen.dart';
import 'package:shop_venue/screens/product_overview_screen.dart';
import 'package:shop_venue/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Samik Maharjan'),
            accountEmail: Text('samikmaharjan55@gmail.com'),
            currentAccountPicture: CircleAvatar(
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
                  builder: (ctx) => OrderScreen(), settings: RouteSettings()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacement(CustomRoute(
                  builder: (ctx) => UserProductScreen(),
                  settings: RouteSettings()));
            },
          ),
          const Divider(),
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
