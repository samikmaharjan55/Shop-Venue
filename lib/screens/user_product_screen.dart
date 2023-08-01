import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/providers/products_provider.dart';
import 'package:shop_venue/screens/edit_product_screen.dart';
import 'package:shop_venue/widgets/app_drawer.dart';
import 'package:shop_venue/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = "/user_product_screen";
  const UserProductScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<Products>(
                    builder: (ctx, products, _) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (ctx, index) => UserProductItem(
                          productsData.items[index].title,
                          productsData.items[index].imageURL,
                          productsData.items[index].id,
                        ),
                        itemCount: productsData.items.length,
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
