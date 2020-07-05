import 'package:easy_order/src/models/product/productArguments.dart';
import 'package:easy_order/src/utils/currency_converter.dart';
import 'package:easy_order/src/views/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductList extends StatefulWidget {
  final ProductArguments _products;

  ProductList({Key key, @required ProductArguments products})
      : assert(products != null),
        _products = products,
        super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

Widget _leftWidget(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Tab(
          icon: Image.asset('images/icon_arrow.png'),
        ),
      ),
    );

Widget _rightWidget(BuildContext context) => GestureDetector(
      onTap: () {},
      child: Tab(
        icon: Image.asset('images/icon_shopping_cart.png'),
      ),
    );

class _ProductListState extends State<ProductList> {
  ProductArguments get _products => widget._products;
  final SlidableController _slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PRODUITS',
        gradientBegin: Colors.red[700],
        grandientEnd: Colors.red[300],
        leftWidget: _leftWidget(context),
        rightWidget: _rightWidget(context),
      ),
      body: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            margin: EdgeInsets.all(0.0),
            shadowColor: Colors.grey[50],
            elevation: 5.0,
            color: Colors.grey[100],
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text('Recherche..'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                separatorBuilder: (context, i) => Divider(),
                itemCount: _products.products.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: null,
                      child: Slidable(
                        actionPane: SlidableScrollActionPane(),
                        actionExtentRatio: 0.25,
                        key: Key(_products.products[i].id),
                        controller: _slidableController,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: !_products.products[i].picture
                                    .startsWith("images/")
                                ? NetworkImage(_products.products[i].picture)
                                : AssetImage(_products.products[i].picture),
                            backgroundColor: Colors.grey[300],
                          ),
                          title: Text(_products.products[i].name),
                          subtitle: Text(
                            _products.products[i].description,
                          ),
                          trailing: Icon(Icons.shopping_cart),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Modifier',
                            color: Colors.grey[200],
                            icon: Icons.edit,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red[400],
        child: Icon(Icons.add),
      ),
    );
  }
}
