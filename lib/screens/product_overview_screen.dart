// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/providers/cart_provider.dart';
import 'package:shop_venue/providers/products_provider.dart';
import 'package:shop_venue/screens/cart_screen.dart';
import 'package:shop_venue/widgets/app_drawer.dart';
import 'package:shop_venue/widgets/badges.dart';
import 'package:shop_venue/widgets/custom_search_delegate.dart';
import 'package:shop_venue/widgets/product_grid.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);
  static const routeName = "/product_overview_screen";

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavourites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
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
          // consumer only affects the part that needs to rebuild
          // rather than refreshing the whole screen
          Consumer<Cart>(
            builder: (_, cart, child) {
              return Badges(
                value: cart.itemCount.toString(),
                child: child!,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(
              _showFavourites,
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
          },
          child: const Icon(Icons.search)),
    );
  }
}
