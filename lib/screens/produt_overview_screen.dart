import 'package:flutter/material.dart';
import 'package:shop_venue/widgets/product_item.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop Venue',
          style: TextStyle(fontFamily: "Lato"),
        ),
      ),
      body: GridView.builder(
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (ctx, index) {
            return const ProductItem();
          }),
    );
  }
}
