import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:easy_order/src/models/product/productArguments.dart';
import 'package:easy_order/src/utils/currency_converter.dart';
import 'package:easy_order/src/views/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
                      onTap: () {},
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
                          trailing: Icon(Icons.add_shopping_cart),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Modifier',
                            color: Colors.grey[200],
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.pushNamed(context, '/manageProduct',
                                  arguments: ManageProductArguments(
                                      _products.products[i],
                                      _products.supplier));
                            },
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
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.red[400],
        animatedIcon: AnimatedIcons.add_event,
        curve: Curves.bounceIn,
        tooltip: 'Nouveau produit',
        children: [
          SpeedDialChild(
            child: Icon(Icons.note_add),
            backgroundColor: Colors.green[300],
            label: 'Via un fichier .csv',
            onTap: () {},
          ),
          SpeedDialChild(
              child: Icon(Icons.edit),
              backgroundColor: Colors.blue[400],
              label: 'Via un formulaire',
              onTap: () {
                Navigator.pushNamed(context, '/manageProduct',
                    arguments:
                        ManageProductArguments(null, _products.supplier));
              }),
        ],
      ),
    );
  }
}
