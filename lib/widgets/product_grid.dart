import 'package:flutter/material.dart';
import 'package:shop_venue/model/products.dart';
import 'package:shop_venue/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  Products products = Products();

  ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: products.items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (ctx, index) {
          return ProductItem(
            title: products.items[index].title,
            imgUrl: products.items[index].imageURL,
          );
        });
  }
}
