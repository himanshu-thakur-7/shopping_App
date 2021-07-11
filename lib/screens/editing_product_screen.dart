import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditingProductScreen extends StatefulWidget {
  static const routeName = '/editingScreen';
  @override
  _EditingProductScreenState createState() => _EditingProductScreenState();
}

class _EditingProductScreenState extends State<EditingProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _imgFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, description: '', title: '', price: 0, imageUrl: '');

  var _isInit = true;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _imgFocusNode.addListener(_updateImgUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context).settings.arguments as String;
      if (productID != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .getProductById(productID);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imgUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImgUrl() {
    if (!_imgFocusNode.hasFocus) {
      if ((!_imgUrlController.text.startsWith('http') &&
              !_imgUrlController.text.startsWith('https')) ||
          (!_imgUrlController.text.endsWith('.jpg') &&
              !_imgUrlController.text.endsWith('.png') &&
              !(_imgUrlController.text.endsWith('jpeg')) &&
              !_imgUrlController.text.endsWith('svg'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _imgFocusNode.removeListener(_updateImgUrl);
    _descFocusNode.dispose();
    _priceFocusNode.dispose();
    _imgUrlController.dispose();
    _imgFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .update(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false).add(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Aww..Snap'),
              content: Text('Something Went Wrong'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            );
          },
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }

    // print(_editedProduct.title);
    // print(_editedProduct.price);
    // print(_editedProduct.description);
    // print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (value) {
                        _editedProduct = Product(
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          title: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price ';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter number greater than 0';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Price (INR ₹)',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Please enter a description atleast 10 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      // textInputAction: TextInputAction.next,
                      focusNode: _descFocusNode,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editedProduct = Product(
                            description: value,
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Container(
                            child: (_imgUrlController.text.isEmpty)
                                ? Text('no image')
                                : FittedBox(
                                    child: Image.network(
                                      _imgUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide image url';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please provide a valid url';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !(value.endsWith('jpeg')) &&
                                  !value.endsWith('svg')) {
                                return 'Please provide url of image file';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Image URl'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imgUrlController,
                            focusNode: _imgFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                description: _editedProduct.description,
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                imageUrl: value,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
