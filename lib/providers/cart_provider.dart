import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // total length of cart
  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  // this adds item to cart
  void addToCart(String productId, String title, double price) {
    const url =
        "https://shop-venue-344b6-default-rtdb.firebaseio.com/cart.json";
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      // no items in the cart
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  // total amount
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.price;
    });
    return total;
  }

  // remove single item from cart
  void removeFromCart(String id) {
    _items.remove(id);
    notifyListeners();
  }

  //clear cart
  void clearCart() {
    _items = {};
    notifyListeners();
  }

  //remove single item
  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }
    if (_items[productID]!.quantity > 1) {
      _items.update(productID, (existingCartItems) {
        return CartItem(
            id: existingCartItems.id,
            title: existingCartItems.title,
            price: existingCartItems.price,
            quantity: existingCartItems.quantity - 1);
      });
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }
}
