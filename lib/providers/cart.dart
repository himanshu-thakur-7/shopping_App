import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final double price;
  final String titile;
  final int qty;
  final String imgUrl;

  CartItem(
      {@required this.id,
      @required this.price,
      @required this.qty,
      @required this.titile,
      @required this.imgUrl});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  int get totCartItems {
    return _items.length;
  }

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get getTotal {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.qty;
    });
    return total;
  }

  void removeItem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].qty > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            price: existingCartItem.price,
            qty: existingCartItem.qty - 1,
            titile: existingCartItem.titile,
            imgUrl: existingCartItem.imgUrl),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addItem(
      String prodId, String prodTitle, double prodPrice, String prodImgUrl) {
    final url = 'https://shopapp-dc3e7.firebaseio.com/products.json';

    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              price: existingCartItem.price,
              qty: existingCartItem.qty + 1,
              titile: existingCartItem.titile,
              imgUrl: existingCartItem.imgUrl));
    } else {
      _items.putIfAbsent(
          prodId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: prodPrice,
              qty: 1,
              titile: prodTitle,
              imgUrl: prodImgUrl));
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
