import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/utils/validators.dart';
import 'package:flutter/material.dart';

typedef OnSaveCallback = Function(Entreprise entreprise, bool editing);
typedef OnDeleteCallback = Function(Entreprise entreprise);

class ManageEntrepriseScreen extends StatefulWidget {
  final OnSaveCallback onSave;
  final OnDeleteCallback onDelete;

  ManageEntrepriseScreen(
      {Key key, @required this.onSave, @required this.onDelete})
      : super(key: key);

  @override
  _ManageEntrepriseScreen createState() => _ManageEntrepriseScreen();
}

class _ManageEntrepriseScreen extends State<ManageEntrepriseScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _tel;
  String _picture;

  @override
  Widget build(BuildContext context) {
    final Entreprise editingEnt =
        ModalRoute.of(context).settings.arguments as Entreprise;
    List<Widget> actions = [];
    if (editingEnt != null) {
      actions.add(
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Suppression"),
                    content: Text(
                        "Voulez-vous vraiment supprimer cette entreprise ? "),
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
                          widget.onDelete(editingEnt);
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
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        actions: actions,
        title: Text(
          editingEnt != null
              ? 'Modifier une entreprise'
              : 'Ajouter une entreprise',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: editingEnt != null ? editingEnt.name : '',
                decoration: InputDecoration(
                  labelText: 'Nom',
                ),
                validator: (value) {
                  return value.isEmpty ? 'Veuillez entrer un nom' : null;
                },
                onSaved: (newValue) => _name = newValue,
              ),
              TextFormField(
                initialValue: editingEnt != null ? editingEnt.email : '',
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  return !Validators.isValidEmail(value)
                      ? 'Veuillez entrer un email valide'
                      : null;
                },
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => _email = newValue,
              ),
              TextFormField(
                initialValue: editingEnt != null ? editingEnt.tel : '',
                decoration: InputDecoration(
                  labelText: 'Tel',
                ),
                validator: (value) {
                  return value.isEmpty
                      ? 'Veuillez entrer un numéro valide'
                      : null;
                },
                keyboardType: TextInputType.phone,
                onSaved: (newValue) => _tel = newValue,
              ),
              TextFormField(
                initialValue: editingEnt != null ? editingEnt.picture : '',
                decoration: InputDecoration(
                  labelText: 'Logo',
                ),
                onSaved: (newValue) => _picture = newValue,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Entreprise ent;
            if (editingEnt != null) {
              ent = Entreprise(
                  id: editingEnt.id,
                  name: _name,
                  email: _email,
                  tel: _tel,
                  picture: _picture);
            } else {
              ent = Entreprise(
                  name: _name, email: _email, tel: _tel, picture: _picture);
            }

            widget.onSave(ent, editingEnt != null);
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.red[400],
      ),
    );
  }
}
