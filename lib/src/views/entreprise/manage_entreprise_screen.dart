import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/utils/validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String _pathPicture;

  void _openFileExplorer() async {
    try {
      _pathPicture = null;
      _pathPicture = await FilePicker.getFilePath(
        type: FileType.image,
      );
    } on PlatformException catch (e) {
      print("Cannot open file explorer : $e");
    }
  }

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
        backgroundColor: Colors.teal[400],
        actions: actions,
        title: Text(
          editingEnt != null
              ? 'Modifier une entreprise'
              : 'Ajouter une entreprise',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextFormField(
                    initialValue: editingEnt != null ? editingEnt.name : '',
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[200],
                        ),
                      ),
                      labelText: 'Nom',
                      suffixIcon: Icon(Icons.perm_identity),
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'Veuillez entrer un nom' : null;
                    },
                    onSaved: (newValue) => _name = newValue,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextFormField(
                    initialValue: editingEnt != null ? editingEnt.email : '',
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[200],
                        ),
                      ),
                      labelText: 'Email',
                      suffixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      return !Validators.isValidEmail(value)
                          ? 'Veuillez entrer un email valide'
                          : null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (newValue) => _email = newValue,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextFormField(
                    initialValue: editingEnt != null ? editingEnt.tel : '',
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[200],
                        ),
                      ),
                      labelText: 'Tel',
                      suffixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      return value.isEmpty
                          ? 'Veuillez entrer un numéro valide'
                          : null;
                    },
                    keyboardType: TextInputType.phone,
                    onSaved: (newValue) => _tel = newValue,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue:
                            editingEnt != null ? editingEnt.picture : '',
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[200],
                            ),
                          ),
                          labelText: 'Logo',
                          hintText: 'Entrez un lien',
                          hintStyle: TextStyle(
                            fontSize: 12.0,
                          ),
                          suffixIcon: Icon(Icons.picture_in_picture),
                        ),
                        onSaved: (newValue) => _picture = newValue,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            Text(' OU '),
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.teal[100],
                          radius: 40.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.file_upload,
                              color: Colors.teal,
                            ),
                            onPressed: _openFileExplorer,
                            iconSize: 50.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                picture: _pathPicture ?? _picture,
              );
            } else {
              ent = Entreprise(
                name: _name,
                email: _email,
                tel: _tel,
                picture: _pathPicture ?? _picture,
              );
            }

            widget.onSave(ent, editingEnt != null);
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.teal[400],
      ),
    );
  }
}
