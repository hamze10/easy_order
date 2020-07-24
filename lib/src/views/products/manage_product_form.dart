import 'package:easy_order/src/blocs/manage_product_bloc/manage_product_bloc.dart';
import 'package:easy_order/src/models/product/currency.dart';
import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/repositories/product/firebase_product_repository.dart';
import 'package:easy_order/src/utils/currency_converter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageProductForm extends StatefulWidget {
  final FirebaseProductRepository _productRepository;
  final ManageProductArguments _manageProductArguments;

  ManageProductForm({
    Key key,
    @required FirebaseProductRepository productRepository,
    @required ManageProductArguments manageProductArguments,
  })  : assert(productRepository != null && manageProductArguments != null),
        _productRepository = productRepository,
        _manageProductArguments = manageProductArguments,
        super(key: key);

  @override
  _ManageProductFormState createState() => _ManageProductFormState();
}

class _ManageProductFormState extends State<ManageProductForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ManageProductBloc _manageProductBloc;

  String _name;
  String _description;
  String _typeProduct;
  Currency _currency;
  double _price;
  String _picture;
  String _pathPicture;

  ManageProductArguments get editingProd => widget._manageProductArguments;

  void _openFileExplorer() async {
    try {
      _pathPicture = null;
      _pathPicture = await FilePicker.getFilePath(
        type: FileType.image,
      );
    } on PlatformException catch (e) {
      print('ERROR _openFileExplorer : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _manageProductBloc = BlocProvider.of<ManageProductBloc>(context);
  }

  void _onAddProduct(ManageProductArguments mpa) {
    _manageProductBloc.add(
      AddProduct(mpa.product, mpa.supplier),
    );
  }

  void _onUpdateProduct(ManageProductArguments mpa) {
    _manageProductBloc.add(
      UpdateProduct(mpa.product),
    );
  }

  void _onDeleteProduct(ManageProductArguments mpa) {
    _manageProductBloc.add(
      DeleteProduct(mpa.product, mpa.supplier),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (editingProd.product != null) {
      actions.add(
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    title: Text("Suppression"),
                    content:
                        Text("Voulez-vous vraiment supprimer ce produit ? "),
                    actions: [
                      FlatButton(
                        child: Text("Non"),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                      FlatButton(
                        child: Text("Oui"),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  );
                }).then((value) {
              if (value == true) {
                _onDeleteProduct(editingProd);
              }
            });
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        actions: actions,
        title: Text(
          editingProd.product != null
              ? 'Modifier un produit'
              : 'Ajouter un produit',
        ),
      ),
      body: BlocListener<ManageProductBloc, ManageProductState>(
        listener: (context, state) {
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Impossible d\'effectuer l\'opération.',
                      ),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red[300],
                ),
              );
          }
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Opération en cours...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Success !'),
                      Icon(Icons.check),
                    ],
                  ),
                  backgroundColor: Colors.green[300],
                ),
              );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ManageProductBloc, ManageProductState>(
          builder: (context, state) {
            return SafeArea(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: TextFormField(
                                initialValue: editingProd.product != null
                                    ? editingProd.product.name
                                    : '',
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  labelText: 'Nom',
                                  suffixIcon: Icon(Icons.perm_identity),
                                ),
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Veuillez entrer un nom'
                                      : null;
                                },
                                onSaved: (newValue) => _name = newValue,
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: TextFormField(
                                initialValue: editingProd.product != null
                                    ? editingProd.product.description
                                    : '',
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  labelText: 'Description',
                                  suffixIcon: Icon(Icons.description),
                                ),
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Veuillez entrer une description'
                                      : null;
                                },
                                onSaved: (newValue) => _description = newValue,
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: TextFormField(
                                initialValue: editingProd.product != null
                                    ? editingProd.product.typeProduct
                                    : '',
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  labelText: 'Type de produit',
                                  suffixIcon: Icon(Icons.category),
                                ),
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Veuillez entrer un type de produit'
                                      : null;
                                },
                                onSaved: (newValue) => _typeProduct = newValue,
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  labelText: 'Devise',
                                  suffixIcon: Icon(Icons.euro_symbol),
                                ),
                                value: editingProd.product != null
                                    ? CurrencyConvertor.convert(
                                        editingProd.product.currency)
                                    : _currency != null
                                        ? CurrencyConvertor.convert(_currency)
                                        : '€',
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 11.0,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _currency =
                                        CurrencyConvertor.toCurrency(newValue);
                                  });
                                },
                                onSaved: (String newValue) => _currency =
                                    CurrencyConvertor.toCurrency(newValue),
                                items: CurrencyConvertor.allValuesInString()
                                    .map<DropdownMenuItem<String>>(
                                        (String val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: TextFormField(
                                initialValue: editingProd.product != null
                                    ? editingProd.product.price.toString()
                                    : '',
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  labelText: 'Prix',
                                  suffixIcon: Icon(Icons.monetization_on),
                                ),
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Veuillez entrer un prix'
                                      : null;
                                },
                                keyboardType: TextInputType.number,
                                onSaved: (newValue) =>
                                    _price = double.parse(newValue),
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    initialValue: editingProd.product != null
                                        ? editingProd.product.picture
                                        : '',
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[200],
                                        ),
                                      ),
                                      labelText: 'Photo du produit',
                                      hintText: 'Entrez un lien',
                                      hintStyle: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                      suffixIcon:
                                          Icon(Icons.picture_in_picture),
                                    ),
                                    onSaved: (newValue) => newValue == ""
                                        ? _picture =
                                            "images/unknown_product.png"
                                        : _picture = newValue,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 16.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(' OU '),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.teal[100],
                                      radius: 25.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.file_upload,
                                          color: Colors.teal,
                                          size: 25.0,
                                        ),
                                        onPressed: _openFileExplorer,
                                        iconSize: 50.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            ManageProductArguments mpa;
            if (editingProd.product != null) {
              Product prod = Product(
                id: editingProd.product.id,
                name: _name,
                description: _description,
                typeProduct: _typeProduct,
                currency: _currency,
                price: _price,
                picture: _pathPicture ?? _picture,
              );
              mpa = ManageProductArguments(prod, editingProd.supplier);
              _onUpdateProduct(mpa);
            } else {
              Product prod = Product(
                name: _name,
                description: _description,
                typeProduct: _typeProduct.isNotEmpty ? _typeProduct : 'autre',
                currency: _currency,
                price: _price,
                picture: _pathPicture ?? _picture,
              );
              mpa = ManageProductArguments(prod, editingProd.supplier);
              _onAddProduct(mpa);
            }
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.red[400],
      ),
    );
  }
}
