import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageURL;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.imageURL,
      this.isFavourite = false});

  Future<void> toggleIsFavourite(String userId, String authToken) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        "https://shop-venue-344b6-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken";
    try {
      final response =
          await http.put(Uri.parse(url), body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
