import 'package:easy_order/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:easy_order/src/models/entreprise.dart';
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

class _EntrepriseListState extends State<EntrepriseList> {
  List<Entreprise> get _entreprises => widget._entreprise;
  final SlidableController _slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('Mes Entreprises'),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[400],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    widget._displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 40.0,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          separatorBuilder: (context, i) => Divider(),
          itemCount: _entreprises.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/suppliers',
                      arguments: _entreprises[i].suppliers);
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
                    subtitle: Text(
                        _entreprises[i].email + " · " + _entreprises[i].tel),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/manageEntreprise', arguments: null);
        },
        backgroundColor: Colors.teal[400],
        child: Icon(Icons.add),
      ),
    );
  }
}
