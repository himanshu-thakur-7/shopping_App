import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String description;
  final String imageUrl;
  bool isFavorite;
  final double price;
  final String title;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void _setFavVal(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> isToggleFavour(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shopapp-dc3e7.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final res = await http.put(url, body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        _setFavVal(oldStatus);
      }
    } catch (error) {
      _setFavVal(oldStatus);
    }
  }
}
