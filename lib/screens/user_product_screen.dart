import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/model/products.dart';
import 'package:shop_venue/widgets/app_drawer.dart';
import 'package:shop_venue/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = "/user_product_screen";
  const UserProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (ctx, index) => UserProductItem(
            productsData.items[index].title,
            productsData.items[index].imageURL),
        itemCount: productsData.items.length,
      ),
    );
  }
}