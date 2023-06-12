// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/model/cart_provider.dart';
import 'package:shop_venue/widgets/badges.dart';
import 'package:shop_venue/widgets/product_grid.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavourites = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop Venue',
          style: TextStyle(fontFamily: "Lato"),
        ),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favourites) {
                    _showFavourites = true;
                  } else {
                    _showFavourites = false;
                  }
                });
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: FilterOptions.Favourites,
                        child: Text("Show Favourites")),
                    const PopupMenuItem(
                        value: FilterOptions.All, child: Text("Show All")),
                  ]),
          Badges(
            value: cart.itemCount.toString(),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ProductGrid(
        _showFavourites,
      ),
    );
  }
}
