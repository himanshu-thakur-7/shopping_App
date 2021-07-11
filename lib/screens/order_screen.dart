import 'package:flutter/material.dart';
import '../widgets/maindrawer.dart';
import '../widgets/order_list_item.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (dataSnapshot.error != null) {
            //error handling mechanism
            return Text(
              'Looks like a problem with connection',
            );
          } else {
            return Consumer<Order>(
              builder: (context, ordersData, _) {
                return ListView.builder(
                  itemBuilder: (ctx, i) => OrderListItem(ordersData.orders[i]),
                  itemCount: ordersData.orders.length,
                );
              },
            );
          }
        },
      ),
    );
  }
}
