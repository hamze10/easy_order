import 'package:easy_order/src/models/manageSupplierArguments.dart';
import 'package:easy_order/src/models/supplierArguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SupplierList extends StatefulWidget {
  final SupplierArguments _suppliers;

  SupplierList({Key key, @required SupplierArguments suppliers})
      : assert(suppliers != null),
        _suppliers = suppliers,
        super(key: key);

  @override
  _SupplierListState createState() => _SupplierListState();
}

class _SupplierListState extends State<SupplierList> {
  SupplierArguments get _suppliers => widget._suppliers;
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
          itemCount: _suppliers.suppliers.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: null,
                child: Slidable(
                  actionPane: SlidableScrollActionPane(),
                  actionExtentRatio: 0.25,
                  key: Key(_suppliers.suppliers[i].id),
                  controller: _slidableController,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          !_suppliers.suppliers[i].picture.startsWith("images/")
                              ? NetworkImage(_suppliers.suppliers[i].picture)
                              : AssetImage(_suppliers.suppliers[i].picture),
                      backgroundColor: Colors.grey[300],
                    ),
                    title: Text(_suppliers.suppliers[i].name),
                    subtitle: Text(_suppliers.suppliers[i].email +
                        " · " +
                        _suppliers.suppliers[i].tel),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Modifier',
                      color: Colors.grey[200],
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.pushNamed(context, '/manageSupplier',
                            arguments: ManageSupplierArguments(
                                _suppliers.suppliers[i],
                                _suppliers.entreprise));
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/manageSupplier',
              arguments: ManageSupplierArguments(
                null,
                _suppliers.entreprise,
              ));
        },
        backgroundColor: Colors.teal[400],
        child: Icon(Icons.add),
      ),
    );
  }
}
