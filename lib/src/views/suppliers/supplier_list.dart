import 'package:easy_order/src/blocs/suppliers_bloc/suppliers_bloc.dart';
import 'package:easy_order/src/models/order.dart';
import 'package:easy_order/src/models/suppliers/manageSupplierArguments.dart';
import 'package:easy_order/src/views/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SupplierList extends StatefulWidget {
  final Order _suppliers;

  SupplierList({Key key, @required Order suppliers})
      : assert(suppliers != null),
        _suppliers = suppliers,
        super(key: key);

  @override
  _SupplierListState createState() => _SupplierListState();
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

class _SupplierListState extends State<SupplierList> {
  Order get _suppliers => widget._suppliers;
  final SlidableController _slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        gradientBegin: Colors.grey[50],
        grandientEnd: Colors.grey[50],
        leftWidget: _leftWidget(context),
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Fournisseurs',
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
                    BlocProvider.of<SuppliersBloc>(context)
                      ..add(LoadSuppliers(
                          _suppliers.fromEntreprise, _suppliers.entreprise));
                  },
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<SuppliersBloc>(context)
                    ..add(LoadSuppliers(
                        _suppliers.fromEntreprise, _suppliers.entreprise));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    separatorBuilder: (context, i) => Divider(),
                    itemCount: _suppliers.fromEntreprise.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/products',
                              arguments: _suppliers.copyWith(
                                  fromSupplier:
                                      _suppliers.fromEntreprise[i].products,
                                  supplier: _suppliers.fromEntreprise[
                                      i]), /*ProductArguments(
                                _suppliers.fromEntreprise[i].products,
                                _suppliers.fromEntreprise[i],
                              ),*/
                            );
                          },
                          child: Card(
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            color: Colors.red[400],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Slidable(
                                actionPane: SlidableScrollActionPane(),
                                actionExtentRatio: 0.25,
                                key: Key(_suppliers.fromEntreprise[i].id),
                                controller: _slidableController,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: !_suppliers
                                            .fromEntreprise[i].picture
                                            .startsWith("images/")
                                        ? NetworkImage(_suppliers
                                            .fromEntreprise[i].picture)
                                        : AssetImage(_suppliers
                                            .fromEntreprise[i].picture),
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  title: Text(
                                    _suppliers.fromEntreprise[i].name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Fredoka',
                                    ),
                                  ),
                                  subtitle: Text(
                                    _suppliers.fromEntreprise[i].email +
                                        " · " +
                                        _suppliers.fromEntreprise[i].tel,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
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
                                      Navigator.pushNamed(
                                          context, '/manageSupplier',
                                          arguments: ManageSupplierArguments(
                                              _suppliers.fromEntreprise[i],
                                              _suppliers.entreprise));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/manageSupplier',
              arguments: ManageSupplierArguments(
                null,
                _suppliers.entreprise,
              ));
        },
        backgroundColor: Colors.red[400],
        icon: Icon(Icons.person_add),
        label: Text('Nouveau fournisseur'),
      ),
    );
  }
}
