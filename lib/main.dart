import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/helper/custom_route.dart';
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
  runApp(const SplashClass());
}

class SplashClass extends StatelessWidget {
  const SplashClass({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
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
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', [], ''),
          update: (BuildContext context, Auth auth, Orders? previousOrders) {
            return Orders(
                auth.token!,
                previousOrders == null ? [] : previousOrders.orders,
                auth.userId!);
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop Venue',
        theme: ThemeData(
          fontFamily: "Lato",
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.red,
            primary: Colors.blueGrey,
          ),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          }),
        ),
        home: const SplashBetween(),
        routes: {
          ProductDetails.routename: (ctx) => const ProductDetails(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrderScreen.routeName: (ctx) => const OrderScreen(),
          UserProductScreen.routeName: (ctx) => const UserProductScreen(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          AuthScreen.routeName: (ctx) => const AuthScreen(),
          ProductOverviewScreen.routeName: (ctx) =>
              const ProductOverviewScreen(),
        },
      ),
    );
  }
}

class SplashBetween extends StatefulWidget {
  const SplashBetween({super.key});

  @override
  State<SplashBetween> createState() => _SplashBetweenState();
}

class _SplashBetweenState extends State<SplashBetween> {
  bool isInit = true;
  bool isLogin = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInit) {
      checkLogin();
    }
    isInit = false;
  }

  void checkLogin() async {
    isLogin = await Provider.of<Auth>(context, listen: false).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen.navigate(
        name: "assets/images/splash.flr",
        fit: BoxFit.cover,
        transitionsBuilder: (context, animation, secondanimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeIn));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        backgroundColor: Colors.blueGrey,
        startAnimation: "loading",
        loopAnimation: "loading",
        until: () => Future.delayed(
          const Duration(seconds: 3),
        ),
        alignment: Alignment.center,
        next: (_) =>
            isLogin ? const ProductOverviewScreen() : const AuthScreen(),
      ),
    );
  }
}
