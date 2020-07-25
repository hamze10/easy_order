import 'package:easy_order/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:easy_order/src/models/entreprise/entreprise.dart';
import 'package:easy_order/src/models/order.dart';
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
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('images/unknown_supplier.png'),
              backgroundColor: Colors.grey[100],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                (DateTime.now().hour + 1 > 18 ||
                        (DateTime.now().hour + 1 >= 0 &&
                            DateTime.now().hour + 1 <= 5))
                    ? 'Bonsoir !'
                    : 'Bonjour !',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                ),
              ),
            )
          ],
        ),
      ),
    );

class _EntrepriseListState extends State<EntrepriseList> {
  List<Entreprise> get _entreprises => widget._entreprise;
  String get _name => widget._displayName;
  final SlidableController _slidableController = SlidableController();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: CustomAppBar(
        title: '',
        gradientBegin: Colors.grey[50],
        grandientEnd: Colors.grey[50],
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
      body: Container(
        color: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Entreprises',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 38.0,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: _entreprises.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/suppliers',
                            arguments: Order(
                              nameUser: _name,
                              entreprise: _entreprises[i],
                              fromEntreprise: _entreprises[i].suppliers,
                              supplier: null,
                              fromSupplier: null,
                              product: null,
                              quantity: -1,
                            ), /*SupplierArguments(
                              _entreprises[i].suppliers,
                              _entreprises[i],
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Slidable(
                              actionPane: SlidableScrollActionPane(),
                              actionExtentRatio: 0.25,
                              key: Key(_entreprises[i].id),
                              controller: _slidableController,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: !_entreprises[i]
                                          .picture
                                          .startsWith("images/")
                                      ? NetworkImage(_entreprises[i].picture)
                                      : AssetImage(_entreprises[i].picture),
                                  backgroundColor: Colors.grey[300],
                                ),
                                title: Text(
                                  _entreprises[i].name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Fredoka',
                                  ),
                                ),
                                subtitle: Text(
                                  _entreprises[i].email +
                                      " · " +
                                      _entreprises[i].tel,
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
                                        context, '/manageEntreprise',
                                        arguments: _entreprises[i]);
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/manageEntreprise', arguments: null);
        },
        backgroundColor: Colors.red[400],
        icon: Icon(Icons.add_circle),
        label: Text("Nouvelle entreprise"),
      ),
    );
  }
}
