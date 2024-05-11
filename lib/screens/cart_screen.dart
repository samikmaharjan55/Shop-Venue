import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/providers/cart_provider.dart' show Cart;
import 'package:shop_venue/providers/orders_provider.dart';
import 'package:shop_venue/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/cart_screen";

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(
                    cart,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (context, i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      title: cart.items.values.toList()[i].title,
                      productId: cart.items.keys.toList()[i],
                      price: cart.items.values.toList()[i].price,
                      quantity: cart.items.values.toList()[i].quantity,
                    )),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final cart;
  const OrderButton(this.cart, {super.key});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context, listen: false);
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : TextButton(
            onPressed: widget.cart.totalAmount <= 0
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (widget.cart.items.isNotEmpty ||
                        widget.cart.totalAmount != 0) {
                      await order.addOrder(widget.cart.items.values.toList(),
                          widget.cart.totalAmount);
                      widget.cart.clearCart();
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
            child: Text(
              "ORDER NOW",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).primaryColor),
            ),
          );
  }
}
