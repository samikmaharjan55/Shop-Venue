import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_venue/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  final String _userId;
  final String _authToken;
  Orders(this._authToken, this._orders, this._userId);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  // adds order from cart to order
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://shop-venue-344b6-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken";
    try {
      final response = http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'title': cp.title,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
              id: DateTime.now().toString(),
              amount: total,
              products: cartProducts,
              dateTime: DateTime.now()));
      notifyListeners();
    } catch (error) {
      //print(error);
      rethrow;
    }
  }

  // fetching orders from the firebase
  Future<void> fetchAndSetOrders() async {
    final url =
        "https://shop-venue-344b6-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (extractedData == null) {
        return;
      }
      //print(extractedData.toString());
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
            id: orderId,
            amount: double.parse(orderData['amount'].toString()),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      quantity: item['quantity'],
                      price: double.parse(item['price'].toString()),
                      title: item['title'],
                    ))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
