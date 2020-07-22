import 'package:badges/badges.dart';
import 'package:easy_order/src/models/order.dart';
import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/utils/currency_converter.dart';
import 'package:easy_order/src/views/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

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
  PanelController _pc = PanelController();
  bool _isOpen = false;
  List<Order> myOrders = [];

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

  Widget _rightWidget() => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: GestureDetector(
          onTap: () {
            bool previousOpen = _isOpen;
            setState(() {
              _isOpen = !_isOpen;
            });

            if (previousOpen) return _pc.close().then((value) => _pc.hide());
            return _pc.show().then((value) => _pc.open());
          },
          child: Badge(
            animationType: BadgeAnimationType.slide,
            badgeColor: Colors.green[200],
            position: BadgePosition.bottomLeft(),
            badgeContent: Text(myOrders.length.toString()),
            child: Tab(
              icon: Image.asset('images/icon_shopping_cart.png'),
            ),
          ),
        ),
      );

  bool addToCart(Order orderWithQuantity) {
    bool result = false;
    setState(() {
      List<String> productsId = myOrders.map((e) => e.product.id).toList();
      if (!productsId.contains(orderWithQuantity.product.id)) {
        myOrders.add(orderWithQuantity);
        result = true;
      }
    });
    return result;
  }

  void removeToCart(Order order) {
    setState(() {
      myOrders.remove(order);
    });
  }

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
      body: Stack(
        children: <Widget>[
          Column(
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
                            child: ListItem(
                              _products.fromSupplier[i],
                              _products,
                              addToCart,
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                color: Colors.transparent,
                                foregroundColor: Colors.black,
                                iconWidget: CircleAvatar(
                                  backgroundColor: Colors.orange[400],
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
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
          SlidingUpPanel(
            backdropEnabled: true,
            backdropOpacity: 0.7,
            onPanelClosed: () {
              setState(() {
                _isOpen = !_isOpen;
              });
            },
            onPanelOpened: () {
              setState(() {
                _isOpen = !_isOpen;
              });
            },
            minHeight: 0,
            controller: _pc,
            panel: OrderPanel(myOrders, removeToCart),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        visible: !_isOpen,
        backgroundColor: Colors.red[400],
        animatedIcon: AnimatedIcons.add_event,
        curve: Curves.bounceIn,
        tooltip: 'Nouveau produit',
        children: [
          SpeedDialChild(
            child: Icon(Icons.note_add),
            backgroundColor: Colors.green[300],
            label: 'Via un fichier .csv',
            onTap: () {
              Navigator.pushNamed(context, '/csvProduct',
                  arguments: ManageProductArguments(null, _products.supplier));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.edit),
            backgroundColor: Colors.blue[400],
            label: 'Via un formulaire',
            onTap: () {
              Navigator.pushNamed(context, '/manageProduct',
                  arguments: ManageProductArguments(null, _products.supplier));
            },
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final Product product;
  final Order order;
  final Function(Order) callback;

  ListItem(this.product, this.order, this.callback);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  Product get product => widget.product;
  Order get order => widget.order;
  int _quantity = 1;
  final _quantityController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
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
            bool value = widget.callback(orderWithQuantity);
            String text = value
                ? 'Produit ajouté au panier.'
                : 'Produit déjà dans le panier.';
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(text),
                backgroundColor: value ? Colors.green[600] : Colors.red[400],
                duration: Duration(milliseconds: 800),
              ),
            );
          },
          child: Icon(
            Icons.add_shopping_cart,
            size: 35.0,
            color: Colors.green[600],
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

class OrderPanel extends StatelessWidget {
  final List<Order> orders;
  final Function(Order) callback;

  OrderPanel(this.orders, this.callback);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
            child: Text(
              'Mes Commandes',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, i) => Divider(),
              itemCount: orders.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        !orders[i].product.picture.startsWith("images/")
                            ? NetworkImage(orders[i].product.picture)
                            : AssetImage(orders[i].product.picture),
                  ),
                  title: Text(orders[i].product.name),
                  subtitle: Text('Quantité : ${orders[i].quantity}'),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.remove_shopping_cart,
                      color: Colors.red[500],
                    ),
                    onPressed: () {
                      callback(orders[i]);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                orders.length > 0
                    ? 'Total : ${orders.fold(0, (previousValue, element) => previousValue + (element.product.price * element.quantity))}${CurrencyConvertor.convert(orders.first.product.currency)}'
                    : '',
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: orders.length == 0
                      ? null
                      : () {
                          String _allOrders = '';
                          orders.forEach(
                              (element) => _allOrders += element.toSend());
                          final Uri _smsLaunch = Uri(
                            scheme: 'sms',
                            path: orders.first.supplier.tel,
                            queryParameters: {
                              'body':
                                  'Commande de ${orders.first.entreprise.name} : $_allOrders',
                            },
                          );

                          launch(_smsLaunch.toString());
                        },
                  child: Text(
                    'Envoyer par sms',
                    style: TextStyle(fontSize: 11.0),
                  ),
                  color: Colors.orange[200],
                ),
                RaisedButton(
                  onPressed: orders.length == 0
                      ? null
                      : () {
                          String _allOrders = '';
                          orders.forEach(
                              (element) => _allOrders += element.toSend());
                          final Uri _emailLaunch = Uri(
                            scheme: 'mailto',
                            path: orders.first.supplier.email,
                            queryParameters: {
                              'subject':
                                  'Commande de ${orders.first.entreprise.name}',
                              'body': _allOrders,
                            },
                          );

                          launch(_emailLaunch.toString());
                        },
                  child: Text(
                    'Envoyer par email',
                    style: TextStyle(fontSize: 11.0),
                  ),
                  color: Colors.blue[200],
                ),
                RaisedButton(
                  onPressed: orders.length == 0
                      ? null
                      : () {
                          String _allOrders = '';
                          String _telSupplier =
                              orders.first.supplier.tel.startsWith("+")
                                  ? orders.first.supplier.tel
                                  : "+32${orders.first.supplier.tel}";
                          orders.forEach(
                              (element) => _allOrders += element.toSend());
                          FlutterOpenWhatsapp.sendSingleMessage(
                              _telSupplier, _allOrders);
                        },
                  child: Text(
                    'Envoyer par WhatsApp',
                    style: TextStyle(fontSize: 9.0),
                  ),
                  color: Colors.green[400],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
