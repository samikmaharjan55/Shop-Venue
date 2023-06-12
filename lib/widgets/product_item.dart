import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/model/cart_provider.dart';
import 'package:shop_venue/model/product.dart';
import 'package:shop_venue/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            loadedProduct.title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: Icon(loadedProduct.isFavourite
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () {
              loadedProduct.toggleIsFavourite();
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addToCart(
                  loadedProduct.id, loadedProduct.title, loadedProduct.price);
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routename,
                arguments: loadedProduct.id);
          },
          child: Image.network(
            loadedProduct.imageURL,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
