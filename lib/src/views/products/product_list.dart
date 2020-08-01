import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:easy_order/src/blocs/products_bloc/products_bloc.dart';
import 'package:easy_order/src/models/order.dart';
import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/utils/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/widgets.dart' as pw;

import '../customAppBar.dart';

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
  PanelController _pc = PanelController();
  bool _isOpen = false;
  List<Order> myOrders = [];

  _onBackPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            title: Row(
              children: <Widget>[
                Icon(Icons.warning),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Attention !"),
                ),
              ],
            ),
            content: Text(
              "Si vous quittez cette page, votre commande sera perdue. Voulez-vous vraiment quitter cette page ?",
            ),
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
        Navigator.pop(context);
      }
    });
  }

  Widget _leftWidget(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: GestureDetector(
          onTap: () {
            if (myOrders.isEmpty) {
              Navigator.pop(context);
            } else {
              _onBackPressed(context);
            }
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
    List<String> _getTypesProduct =
        _products.fromSupplier.map((e) => e.typeProduct).toSet().toList();
    _getTypesProduct.sort();

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        gradientBegin: _isOpen ? Colors.black54 : Colors.grey[50],
        grandientEnd: _isOpen ? Colors.black54 : Colors.grey[50],
        leftWidget: _leftWidget(context),
        rightWidget: _rightWidget(),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (myOrders.isEmpty) {
            Navigator.pop(context);
          } else {
            return _onBackPressed(context);
          }
        },
        child: Stack(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<ProductsBloc>(context)
                  ..add(
                      LoadProducts(_products.fromSupplier, _products.supplier));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Produits',
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 38.0,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          BlocProvider.of<ProductsBloc>(context)
                            ..add(
                              LoadProducts(
                                  _products.fromSupplier, _products.supplier),
                            );
                        },
                        icon: Icon(Icons.refresh),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _getTypesProduct.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    _getTypesProduct[i],
                                    style: TextStyle(
                                      fontFamily: 'Fredoka',
                                      fontSize: 16.0,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 200),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _products.fromSupplier
                                        .where((e) =>
                                            e.typeProduct ==
                                            _getTypesProduct[i])
                                        .length,
                                    itemBuilder: (context, i2) {
                                      final prod = _products.fromSupplier
                                          .where((e) =>
                                              e.typeProduct ==
                                              _getTypesProduct[i])
                                          .toList()[i2];
                                      return ListItem(
                                          prod, _products, addToCart);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SlidingUpPanel(
              backdropEnabled: true,
              backdropOpacity: 0.54,
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
    return GestureDetector(
      onLongPress: () {
        Navigator.pushNamed(context, '/manageProduct',
            arguments: ManageProductArguments(product, order.supplier));
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              height: 80.0,
              width: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: product.picture.startsWith('images/')
                        ? AssetImage(product.picture)
                        : NetworkImage(product.picture),
                    fit: BoxFit.fill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              child: Text(
                product.name,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                product.price.toStringAsFixed(2) +
                    CurrencyConvertor.convert(product.currency),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      width: 50.0,
                      height: 26.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7.0),
                        ),
                        color: Colors.green[600],
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
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
                          backgroundColor:
                              value ? Colors.green[600] : Colors.red[400],
                          duration: Duration(milliseconds: 800),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add_circle,
                      size: 30.0,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    final double trackWidth = parentBox.size.width / 1.50;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class OrderPanel extends StatefulWidget {
  final List<Order> orders;
  final Function(Order) callback;

  OrderPanel(this.orders, this.callback);

  @override
  _OrderPanelState createState() => _OrderPanelState();
}

class _OrderPanelState extends State<OrderPanel> {
  List<Order> get orders => widget.orders;
  Function(Order) get callback => widget.callback;
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, bottom: 24.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Mes Commandes',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30.0,
                    fontFamily: 'Fredoka',
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (favorite) return;
                    setState(() {
                      favorite = true;
                    });
                  },
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite ? Colors.red[400] : Colors.black,
                    size: 30.0,
                  ),
                ),
              ],
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
                          String _allOrders =
                              'Commande de ${orders.first.entreprise.name} : ';
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

Uint8List _generatePDF(List<Order> orders) {
  final pw.Document doc =
      pw.Document(title: 'Commande de ${orders.first.entreprise.name}');

  doc.addPage(pw.Page(build: (pw.Context context) {
    return pw.Row(
      children: <pw.Widget>[
        pw.Expanded(
            child: pw.ListView.separated(
          separatorBuilder: (context, i) => pw.Divider(),
          itemCount: orders.length,
          itemBuilder: (context, i) {
            return pw.Text(
              orders[i].toSend(),
            );
          },
        )),
      ],
    );
  }));
  return doc.save();
}
