import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/model/cart_provider.dart';
import 'package:shop_venue/model/products.dart';
import 'package:shop_venue/screens/product_details_screen.dart';
import 'package:shop_venue/screens/produt_overview_screen.dart';

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
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
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
            )),
        initialRoute: '/',
        routes: {
          "/": (ctx) => const ProductOverviewScreen(),
          ProductDetails.routename: (ctx) => const ProductDetails(),
        },
      ),
    );
  }
}
