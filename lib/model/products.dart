import 'package:flutter/cupertino.dart';
import 'package:shop_venue/model/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [
    Product(
        id: "first",
        title: "Watch",
        price: 2000,
        description: "The best watch you will find anywhere.",
        imageURL:
            "https://www.surfstitch.com/on/demandware.static/-/Sites-ss-master-catalog/default/dwef31ef54/images/MBB-M43BLK/BLACK-WOMENS-ACCESSORIES-ROSEFIELD-WATCHES-MBB-M43BLK_1.JPG",
        isFavourite: false),
    Product(
        id: "second",
        title: "Shoes",
        price: 1500,
        description: "Quality and comfort shoes with fashionable style.",
        imageURL:
            "https://assets.adidas.com/images/w_600,f_auto,q_auto:sensitive,fl_lossy/e06ae7c7b4d14a16acb3a999005a8b6a_9366/Lite_Racer_RBN_Shoes_White_F36653_01_standard.jpg",
        isFavourite: false),
    Product(
        id: "third",
        title: "Laptop",
        price: 80000,
        description: "The compact and powerful gaming laptop under the budget.",
        imageURL:
            "https://cdn.mos.cms.futurecdn.net/6t8Zh249QiFmVnkQdCCtHK.jpg",
        isFavourite: false),
    Product(
        id: "four",
        title: "T-Shirt",
        price: 1000,
        description: "A red color tshirt you can wear at any occassion.",
        imageURL:
            "https://5.imimg.com/data5/LM/NA/MY-49778818/mens-round-neck-t-shirt-500x500.jpg",
        isFavourite: false),
  ];

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
}
