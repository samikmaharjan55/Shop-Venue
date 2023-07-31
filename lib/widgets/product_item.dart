import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/providers/auth_provider.dart';
import 'package:shop_venue/providers/cart_provider.dart';
import 'package:shop_venue/model/product.dart';
import 'package:shop_venue/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
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
          leading: Consumer<Product>(
            builder: (_, prod, child) {
              return IconButton(
                icon: Icon(
                    prod.isFavourite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  prod.toggleIsFavourite(auth.userId!, auth.token!);
                },
                color: Theme.of(context).colorScheme.secondary,
              );
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addToCart(
                  loadedProduct.id, loadedProduct.title, loadedProduct.price);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueGrey,
                  content: const Text('Added item to the cart'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    textColor: Colors.black87,
                    onPressed: () {
                      cart.removeSingleItem(loadedProduct.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routename,
                arguments: loadedProduct.id);
          },
          child: Hero(
            tag: 'product${loadedProduct.id}',
            child: FadeInImage(
              placeholder: AssetImage("assets/images/placeholder.png"),
              image: NetworkImage(
                loadedProduct.imageURL,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
