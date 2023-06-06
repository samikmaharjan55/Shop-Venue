import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/model/products.dart';
import 'package:shop_venue/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool isFavourite;
  const ProductGrid(this.isFavourite, {super.key});

  @override
  Widget build(BuildContext context) {
    final products = isFavourite
        ? Provider.of<Products>(context).favourites
        : Provider.of<Products>(context).items;
    return GridView.builder(
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
            value: products[index],
            child: const ProductItem(),
          );
        });
  }
}
