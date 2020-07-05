import 'package:easy_order/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:easy_order/src/models/entreprise/entreprise.dart';
import 'package:easy_order/src/models/suppliers/supplierArguments.dart';
import 'package:easy_order/src/views/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EntrepriseList extends StatefulWidget {
  final List<Entreprise> _entreprise;
  final String _displayName;

  EntrepriseList({
    Key key,
    @required List<Entreprise> entreprise,
    @required String displayName,
  })  : assert(entreprise != null && displayName != null),
        _entreprise = entreprise,
        _displayName = displayName,
        super(key: key);

  @override
  _EntrepriseListState createState() => _EntrepriseListState();
}

Widget _leftWidget(GlobalKey<ScaffoldState> key) => Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: GestureDetector(
        onTap: () {
          key.currentState.openDrawer();
        },
        child: CircleAvatar(
          backgroundImage: AssetImage('images/unknown_supplier.png'),
          backgroundColor: Colors.grey[100],
        ),
      ),
    );

class _EntrepriseListState extends State<EntrepriseList> {
  List<Entreprise> get _entreprises => widget._entreprise;
  final SlidableController _slidableController = SlidableController();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: CustomAppBar(
        title: 'ENTREPRISES',
        gradientBegin: Colors.red[700],
        grandientEnd: Colors.red[300],
        leftWidget: _leftWidget(_key),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.red[700],
                    Colors.red[300],
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('images/unknown_supplier.png'),
                    backgroundColor: Colors.grey[300],
                    radius: 40.0,
                  ),
                  Text(
                    widget._displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Deconnexion'),
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  AuthenticationLoggedOut(),
                );
              },
            ),
          ],
        ),
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
                itemCount: _entreprises.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/suppliers',
                          arguments: SupplierArguments(
                            _entreprises[i].suppliers,
                            _entreprises[i],
                          ),
                        );
                      },
                      child: Slidable(
                        actionPane: SlidableScrollActionPane(),
                        actionExtentRatio: 0.25,
                        key: Key(_entreprises[i].id),
                        controller: _slidableController,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                !_entreprises[i].picture.startsWith("images/")
                                    ? NetworkImage(_entreprises[i].picture)
                                    : AssetImage(_entreprises[i].picture),
                            backgroundColor: Colors.grey[300],
                          ),
                          title: Text(_entreprises[i].name),
                          subtitle: Text(_entreprises[i].email +
                              " · " +
                              _entreprises[i].tel),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Modifier',
                            color: Colors.grey[200],
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.pushNamed(context, '/manageEntreprise',
                                  arguments: _entreprises[i]);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/manageEntreprise', arguments: null);
        },
        backgroundColor: Colors.red[400],
        child: Icon(Icons.add),
      ),
    );
  }
}
