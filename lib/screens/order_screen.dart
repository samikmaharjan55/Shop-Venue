import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/providers/orders_provider.dart' show Orders;
import 'package:shop_venue/widgets/app_drawer.dart';

import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/order_screen";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return const Center(
                  child:
                      Text('Error Occurred! Something went wrong. Try Again!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, i) => OrderItem(
                      orderData.orders[i],
                    ),
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          },
        ));
  }
}
