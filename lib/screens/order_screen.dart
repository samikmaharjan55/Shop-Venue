import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/model/orders.dart' show Orders;
import 'package:shop_venue/widgets/app_drawer.dart';

import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/order_screen";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(
          orderData[i],
        ),
        itemCount: orderData.length,
      ),
    );
  }
}
