import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/widgets/maindrawer.dart';
import '../widgets/badge.dart';

import '../widgets/product_grid.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

enum filterFavs { Favorites, All }
var _init = true;
var _isLoading = false;

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/productOverview';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showfav = false;

  @override
  void initState() {
    // Provider.of<Products>(context, listen: false).fetchAndSetProduct();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(false)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      // setState(() {
      //   _isLoading = true;
      // });
      // Provider.of<Products>(context, listen: false)
      //     .fetchAndSetProduct(false)
      //     .then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('build prod ovr');
    // final prod = Provider.of<Products>(context);
    // final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: filterFavs.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: filterFavs.All,
                )
              ];
            },
            onSelected: (filterFavs selValue) {
              if (selValue == filterFavs.Favorites) {
                //   prod.showFavorites();
                setState(() {
                  _showfav = true;
                });
              } else {
                setState(() {
                  _showfav = false;
                });
                //   prod.showAll();
              }
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.totCartItems.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showfav),
    );
  }
}
