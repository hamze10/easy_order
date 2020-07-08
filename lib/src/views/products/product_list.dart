import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/models/product/productArguments.dart';
import 'package:easy_order/src/utils/currency_converter.dart';
import 'package:easy_order/src/views/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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

class ProductList extends StatefulWidget {
  final ProductArguments _products;

  ProductList({Key key, @required ProductArguments products})
      : assert(products != null),
        _products = products,
        super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

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
                        child: ListItem(_products.products[i]),
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

class ListItem extends StatefulWidget {
  final Product product;

  ListItem(this.product);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  Product get product => widget.product;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 100.0,
              child: Image(
                height: 80.0,
                image: !product.picture.startsWith("images/")
                    ? NetworkImage(product.picture)
                    : AssetImage(product.picture),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 11.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      product.price.toStringAsFixed(2) +
                          CurrencyConvertor.convert(product.currency),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //Ajouter input pour rentrer la quantité manuellement
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 5.0,
                        trackShape: CustomTrackShape(),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8.0),
                      ),
                      child: Slider(
                        value: _quantity.toDouble(),
                        min: 1,
                        max: 100,
                        label: 'Quantité : $_quantity',
                        divisions: 100,
                        activeColor: Colors.red[400],
                        inactiveColor: Colors.red[50],
                        onChanged: (double newValue) {
                          setState(() {
                            _quantity = newValue.round();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.add_shopping_cart,
            size: 35.0,
            color: Colors.red[600],
          ),
        ),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width / 1.25;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
