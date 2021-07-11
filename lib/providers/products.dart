import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // bool _showFavs = false;

  List<Product> get favitems {
    return _items.where((prod) => prod.isFavorite == true).toList();
  }

  List<Product> get items {
    // if (_showFavs) {
    //   return _items.where((prod) => prod.isFavorite == true).toList();
    // }
    return [..._items];
  }

  Future<void> add(Product newprod) async {
    try {
      final url =
          'https://shopapp-dc3e7.firebaseio.com/products.json?auth=$authToken';
      final response = await http.post(url,
          body: json.encode({
            "title": newprod.title,
            "price": newprod.price,
            "imageUrl": newprod.imageUrl,
            "description": newprod.description,
            "creatorId": userId,
          }));

      final newProduct = Product(
        description: newprod.description,
        id: json.decode(response.body)['name'],
        title: newprod.title,
        price: newprod.price,
        imageUrl: newprod.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetProduct(bool applyFilter) async {
    final filterString =
        applyFilter == true ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopapp-dc3e7.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);

      // print(json.decode(response.body));
      final extractedData = (jsonDecode(response.body) as Map<String, dynamic>);
      if (extractedData == null) {
        return;
      }
      url =
          'https://shopapp-dc3e7.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favResponses = await http.get(url);
      final favData = json.decode(favResponses.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              isFavorite: favData == null ? false : favData[prodId] ?? false,
              price: prodData['price'],
            ),
          );
        },
      );
      _items = loadedProducts;
    } catch (error) {
      throw error;
    }
  }

  Future<void> update(String pId, Product newprod) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == pId);
    if (prodIndex >= 0) {
      final url =
          'https://shopapp-dc3e7.firebaseio.com/products/$pId.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newprod.title,
            'description': newprod.description,
            'imageUrl': newprod.imageUrl,
            'price': newprod.price,
          },
        ),
      );
      _items[prodIndex] = newprod;

      notifyListeners();
    } else {
      print('error');
    }
  }

  Product getProductById(String id) {
    return (_items.firstWhere((prod) => prod.id == id));
  }

  Future<void> delete(String id) async {
    final url =
        'https://shopapp-dc3e7.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('error occured');
    }
    existingProduct = null;
  }

  // void showFavorites() {
  //   _showFavs = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavs = false;
  //   notifyListeners();
  // }
}
