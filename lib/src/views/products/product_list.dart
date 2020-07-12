import 'package:easy_order/src/models/order.dart';
import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/utils/currency_converter.dart';
import 'package:easy_order/src/views/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProductList extends StatefulWidget {
  final Order _products;

  ProductList({Key key, @required Order products})
      : assert(products != null),
        _products = products,
        super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Order get _products => widget._products;
  final SlidableController _slidableController = SlidableController();
  int _quantity = 1;
  final _quantityController = TextEditingController();
  PanelController _pc = PanelController();
  bool _isOpen = false;
  List<Order> myOrders = [];

  @override
  void initState() {
    super.initState();
    _quantityController.value = TextEditingValue(
      text: _quantity.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: _quantity.toString().length),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    return _quantityController.dispose();
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

  Widget _rightWidget() => GestureDetector(
        onTap: () {
          bool previousOpen = _isOpen;
          _isOpen = !_isOpen;
          if (previousOpen) return _pc.close().then((value) => _pc.hide());
          return _pc.show().then((value) => _pc.open());
        },
        child: Tab(
          icon: Image.asset('images/icon_shopping_cart.png'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PRODUITS',
        gradientBegin: Colors.red[700],
        grandientEnd: Colors.red[300],
        leftWidget: _leftWidget(context),
        rightWidget: _rightWidget(),
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        backdropOpacity: 0.7,
        onPanelClosed: () => _isOpen = !_isOpen,
        onPanelOpened: () => _isOpen = !_isOpen,
        minHeight: 0,
        controller: _pc,
        panel: Center(
          child: Text('test sliding'),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
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
                  itemCount: _products.fromSupplier.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Slidable(
                          actionPane: SlidableScrollActionPane(),
                          actionExtentRatio: 0.25,
                          key: Key(_products.fromSupplier[i].id),
                          controller: _slidableController,
                          child:
                              _listItem(_products.fromSupplier[i], _products),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Modifier',
                              color: Colors.grey[200],
                              icon: Icons.edit,
                              onTap: () {
                                Navigator.pushNamed(context, '/manageProduct',
                                    arguments: ManageProductArguments(
                                        _products.fromSupplier[i],
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

  Widget _listItem(Product product, Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 80.0,
              child: Image(
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
                  Row(
                    children: <Widget>[
                      Container(
                        width: 30.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                        ),
                        child: TextFormField(
                          controller: _quantityController,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          onChanged: (String newValue) {
                            setState(() {
                              _quantity = int.parse(newValue);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 5.0,
                            trackShape: CustomTrackShape(),
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 8.0),
                          ),
                          child: Slider(
                            value: _quantity <= 250 ? _quantity.toDouble() : 1,
                            min: 1,
                            max: 250,
                            label: 'Quantité : $_quantity',
                            divisions: 50,
                            activeColor: Colors.red[400],
                            inactiveColor: Colors.red[50],
                            onChanged: (double newValue) {
                              setState(() {
                                _quantity = newValue.round();
                                _quantityController.value = TextEditingValue(
                                  text: _quantity.toString(),
                                  selection: TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _quantity.toString().length),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Order orderWithQuantity =
                order.copyWith(product: product, quantity: _quantity);
            List<String> productsId =
                myOrders.map((e) => e.product.id).toList();
            if (!productsId.contains(orderWithQuantity.product.id)) {
              myOrders.add(orderWithQuantity);
            }
            print("myorders : ${myOrders.length}");
          },
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
