import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/editing_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgurl;
  UserProductItem(this.imgurl, this.title, this.id);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgurl),
      ),
      title: Text(title),
      trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditingProductScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .delete(id);
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Product Deleted Successfully',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } catch (error) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deleting Product Failed',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          )),
    );
  }
}
