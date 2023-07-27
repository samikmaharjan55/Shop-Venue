import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/providers/auth_provider.dart';
import 'package:shop_venue/providers/cart_provider.dart';
import 'package:shop_venue/providers/orders_provider.dart';
import 'package:shop_venue/providers/products_provider.dart';
import 'package:shop_venue/screens/auth_screen.dart';
import 'package:shop_venue/screens/cart_screen.dart';
import 'package:shop_venue/screens/edit_product_screen.dart';
import 'package:shop_venue/screens/order_screen.dart';
import 'package:shop_venue/screens/product_details_screen.dart';
import 'package:shop_venue/screens/product_overview_screen.dart';
import 'package:shop_venue/screens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', [], ''),
          update:
              (BuildContext context, Auth auth, Products? previousProducts) {
            return Products(
                auth.token!,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId!);
          },
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', []),
          update: (BuildContext context, Auth auth, Orders? previousOrders) {
            return Orders(auth.token!,
                previousOrders == null ? [] : previousOrders.orders);
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop Venue',
            theme: ThemeData(
                fontFamily: "Lato",
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: Colors.red,
                  primary: Colors.blueGrey,
                )),
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetails.routename: (ctx) => const ProductDetails(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrderScreen.routeName: (ctx) => const OrderScreen(),
              UserProductScreen.routeName: (ctx) => const UserProductScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
