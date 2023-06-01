import 'package:flutter/material.dart';
import 'package:shop_venue/screens/produt_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Venue',
      theme: ThemeData(
          fontFamily: "Lato",
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.red,
            primary: Colors.blueGrey,
          )),
      home: const ProductOverviewScreen(),
    );
  }
}
