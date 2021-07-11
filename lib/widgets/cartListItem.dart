import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final String imgUrl;
  final String title;
  final double price;
  final int qty;
  final String id;
  final String prodId;

  CartListItem(
      {this.imgUrl, this.id, this.price, this.qty, this.title, this.prodId});

  @override
  Widget build(BuildContext context) {
    double totCost = price * qty;
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(prodId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to remove the item from cart?'),
              actions: <Widget>[
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      Text('No'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      Text('Yes'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          },
        );
      },
      child: Card(
        elevation: 8,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imgUrl),
              radius: 18,
            ),
            title: Text(title),
            subtitle: Row(
              children: <Widget>[
                Text('Price: ₹ $price'),
                SizedBox(
                  width: 7,
                ),
                Text('Quantity: ${qty}'),
              ],
            ),
            trailing: CircleAvatar(
              child: FittedBox(
                child: Text('₹ ${totCost.toStringAsFixed(2)}'),
              ),
              radius: 21,
            ),
          ),
        ),
      ),
    );
  }
}
