import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/widgets/cartListItem.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Card(
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '₹ ${cart.getTotal.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return CartListItem(
                    prodId: cart.items.keys.toList()[i],
                    id: cart.items.values.toList()[i].id,
                    imgUrl: cart.items.values.toList()[i].imgUrl,
                    title: cart.items.values.toList()[i].titile,
                    qty: cart.items.values.toList()[i].qty,
                    price: cart.items.values.toList()[i].price,
                  );
                },
                itemCount: cart.totCartItems,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
      onPressed: (widget.cart.getTotal <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              final ord = Provider.of<Order>(context, listen: false);
              await ord.addOrder(
                  widget.cart.items.values.toList(), widget.cart.getTotal);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
    );
  }
}
