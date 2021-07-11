import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, this._orders);
  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shopapp-dc3e7.firebaseio.com/orders/$userId.json?auth=$authToken';
    final res = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = (json.decode(res.body) as Map<String, dynamic>);
    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderid, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderid,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  qty: item['quantity'],
                  titile: item['title'],
                  imgUrl: item['imageUrl']))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shopapp-dc3e7.firebaseio.com/orders/$userId.json?auth=$authToken';
    final tStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          "amount": total,
          "dateTime": tStamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.titile,
                    "quantity": cp.qty,
                    "price": cp.price,
                    "imageUrl": cp.imgUrl
                  })
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: tStamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
