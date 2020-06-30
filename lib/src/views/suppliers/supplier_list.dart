import 'package:easy_order/src/models/supplier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SupplierList extends StatefulWidget {
  final List<Supplier> _suppliers;

  SupplierList({Key key, @required List<Supplier> suppliers})
      : assert(suppliers != null),
        _suppliers = suppliers,
        super(key: key);

  @override
  _SupplierListState createState() => _SupplierListState();
}

class _SupplierListState extends State<SupplierList> {
  List<Supplier> get _suppliers => widget._suppliers;
  final SlidableController _slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('Fournisseurs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          separatorBuilder: (context, i) => Divider(),
          itemCount: _suppliers.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Slidable(
                  actionPane: SlidableScrollActionPane(),
                  actionExtentRatio: 0.25,
                  key: Key(_suppliers[i].id),
                  controller: _slidableController,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          !_suppliers[i].picture.startsWith("images/")
                              ? NetworkImage(_suppliers[i].picture)
                              : AssetImage(_suppliers[i].picture),
                      backgroundColor: Colors.grey[300],
                    ),
                    title: Text(_suppliers[i].name),
                    subtitle:
                        Text(_suppliers[i].email + " · " + _suppliers[i].tel),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Modifier',
                      color: Colors.grey[200],
                      icon: Icons.edit,
                      onTap: null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.teal[400],
        child: Icon(Icons.add),
      ),
    );
  }
}
