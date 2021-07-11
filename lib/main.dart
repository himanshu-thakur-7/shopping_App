import 'package:flutter/material.dart';
import './screens/splashScreen.dart';
import './screens/editing_product_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, authData, prevProd) => Products(authData.token,
              authData.userId, prevProd == null ? [] : prevProd.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (context, authData, prevOrder) => Order(authData.token,
              authData.userId, prevOrder == null ? [] : prevOrder.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth()
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authresultSnapshot) =>
                        authresultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetail.routeName: (ctx) => ProductDetail(),
              ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditingProductScreen.routeName: (ctx) => EditingProductScreen()
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
