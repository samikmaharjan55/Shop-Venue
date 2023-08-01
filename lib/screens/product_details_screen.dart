import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/providers/products_provider.dart';

class ProductDetails extends StatelessWidget {
  static const String routename = "/product_detail_screen";

  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final selectedProduct =
        Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(selectedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(selectedProduct.title),
              background: Hero(
                tag: 'product$id',
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    selectedProduct.imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10.0,
            ),
            Text(
              '\$${selectedProduct.price}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(
              height: 700.0,
            ),
          ])),
        ],
      ),
    );
  }
}
