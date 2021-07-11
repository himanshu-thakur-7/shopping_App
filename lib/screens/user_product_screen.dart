import 'package:flutter/material.dart';
import '../screens/editing_product_screen.dart';
import '../widgets/maindrawer.dart';
import '../widgets/userProductitem.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  static const routeName = '/UserProducts';
  @override
  Widget build(BuildContext context) {
    print('build user prod');
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditingProductScreen.routeName);
              },
            )
          ],
        ),
        drawer: MainDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Consumer<Products>(
                  builder: (_, products, child) => ListView.builder(
                    itemBuilder: (context, i) {
                      return Column(
                        children: <Widget>[
                          UserProductItem(products.items[i].imageUrl,
                              products.items[i].title, products.items[i].id),
                          Divider(
                            color: Colors.black54,
                          ),
                        ],
                      );
                    },
                    itemCount: products.items.length,
                  ),
                ),
              ),
            );
          },
        ));
  }
}
