import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';

class OrderListItem extends StatefulWidget {
  final OrderItem order;
  OrderListItem(this.order);

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.order.products.length * 20.0 + 300.0, 500)
          : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '₹ ${widget.order.amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 27),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            //  if (_expanded)
            AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _expanded
                    ? min(widget.order.products.length * 20.0 + 200.0, 280)
                    : 0,
                child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 8,
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.order.products[i].imgUrl),
                            radius: 18,
                          ),
                          title: Text(widget.order.products[i].titile),
                          subtitle: Row(
                            children: <Widget>[
                              Text(
                                  'Price: ₹ ${widget.order.products[i].price}'),
                              SizedBox(
                                width: 7,
                              ),
                              Text('Quantity: ${widget.order.products[i].qty}'),
                            ],
                          ),
                          trailing: CircleAvatar(
                            child: FittedBox(
                              child: Text(
                                  '₹ ${(widget.order.products[i].price * widget.order.products[i].qty).toStringAsFixed(2)}'),
                            ),
                            radius: 21,
                          ),
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
