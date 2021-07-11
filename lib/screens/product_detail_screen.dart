import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/productDetails';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;
    print(productId);
    final loadedProduct =
        Provider.of<Products>(context, listen: false).getProductById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 5,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Hero(
                    tag: productId.toString(),
                    child: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Chip(
                  backgroundColor: Theme.of(context).accentColor,
                  label: Text(
                    '₹ ${loadedProduct.price}',
                    style: TextStyle(fontSize: 29, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        loadedProduct.title,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Center(
                      child: Text(
                        loadedProduct.description,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
