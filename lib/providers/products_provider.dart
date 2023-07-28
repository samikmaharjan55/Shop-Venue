import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_venue/exception/http_exception.dart';
import 'package:shop_venue/model/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String _authToken;
  final String _userId;
  List<Product> _items = [
    // Product(
    //     id: "first",
    //     title: "Watch",
    //     price: 2000,
    //     description: "The best watch you will find anywhere.",
    //     imageURL:
    //         "https://www.surfstitch.com/on/demandware.static/-/Sites-ss-master-catalog/default/dwef31ef54/images/MBB-M43BLK/BLACK-WOMENS-ACCESSORIES-ROSEFIELD-WATCHES-MBB-M43BLK_1.JPG",
    //     isFavourite: false),
    // Product(
    //     id: "second",
    //     title: "Shoes",
    //     price: 1500,
    //     description: "Quality and comfort shoes with fashionable style.",
    //     imageURL:
    //         "https://assets.adidas.com/images/w_600,f_auto,q_auto:sensitive,fl_lossy/e06ae7c7b4d14a16acb3a999005a8b6a_9366/Lite_Racer_RBN_Shoes_White_F36653_01_standard.jpg",
    //     isFavourite: false),
    // Product(
    //     id: "third",
    //     title: "Laptop",
    //     price: 80000,
    //     description: "The compact and powerful gaming laptop under the budget.",
    //     imageURL:
    //         "https://cdn.mos.cms.futurecdn.net/6t8Zh249QiFmVnkQdCCtHK.jpg",
    //     isFavourite: false),
    // Product(
    //     id: "fourth",
    //     title: "T-Shirt",
    //     price: 1000,
    //     description: "A red color tshirt you can wear at any occassion.",
    //     imageURL:
    //         "https://5.imimg.com/data5/LM/NA/MY-49778818/mens-round-neck-t-shirt-500x500.jpg",
    //     isFavourite: false),
  ];

  Products(this._authToken, this._items, this._userId);

  List<Product> get items {
    return [..._items];
  }

  // find the selected product using id
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // show only favourite items
  List<Product> get favourites {
    return _items.where((prodItem) {
      return prodItem.isFavourite;
    }).toList();
  }

  // this function adds new product
  Future<void> addProduct(Product product) async {
    final url =
        "https://shop-venue-344b6-default-rtdb.firebaseio.com/products.json?auth=$_authToken";
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageURL': product.imageURL,
            'creatorId': _userId,
          }));
      // the future gives response after posting to the database
      print(json.decode(response.body)['name']);
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageURL: product.imageURL);
      _items.add(newProduct);
      notifyListeners();
    }
    // if we get an error during post we catch the error and execute accordingly

    catch (error) {
      print(error);
      throw (error);
    }
  }

  // this function fetches the product from firebase
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : "";
    final url =
        "https://shop-venue-344b6-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print('here');
      // print(extractedData.toString());
      final favouriteResponse = await http.get(Uri.parse(
          "https://shop-venue-344b6-default-rtdb.firebaseio.com/userFavourites/$_userId.json?auth=$_authToken"));
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          price: double.parse(prodData['price'].toString()),
          description: prodData['description'],
          imageURL: prodData['imageURL'],
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // this function updates the current product
  Future<void> updateProduct(String id, Product upProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    try {
      if (prodIndex >= 0) {
        final url =
            "https://shop-venue-344b6-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken";
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': upProduct.title,
              'description': upProduct.description,
              'imageURL': upProduct.imageURL,
              'price': upProduct.price,
            }));
        _items[prodIndex] = upProduct;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // this function deletes the current product
  Future<void> deleteProduct(String id) async {
    final url =
        "https://shop-venue-344b6-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken";
    final existingProductIndex = items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException("Could not delete product");
      } else {
        existingProduct == null;
      }
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
  }
}
