import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
//import '../providers/product.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../widgets/productItem.dart';

class ProductGrid extends StatelessWidget {
  final bool showfavs;
  ProductGrid(this.showfavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showfavs ? productsData.favitems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(
              // id: products[i].id,
              // title: products[i].title,
              // imageUrl: products[i].imageUrl,
              ),
        );
      },
      itemCount: products.length,
    );
  }
}
