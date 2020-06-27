import 'package:easy_order/src/blocs/manage_entreprise_bloc/manage_entreprise_bloc.dart';
import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/repositories/firebase_entreprise_repository.dart';
import 'package:easy_order/src/utils/validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageEntrepriseForm extends StatefulWidget {
  final FirebaseEntrepriseRepository _entrepriseRepository;
  final Entreprise _entreprise;

  ManageEntrepriseForm(
      {Key key,
      @required FirebaseEntrepriseRepository entrepriseRepository,
      @required Entreprise entreprise})
      : assert(entrepriseRepository != null),
        _entrepriseRepository = entrepriseRepository,
        _entreprise = entreprise,
        super(key: key);

  @override
  _ManageEntrepriseFormState createState() => _ManageEntrepriseFormState();
}

class _ManageEntrepriseFormState extends State<ManageEntrepriseForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ManageEntrepriseBloc _manageEntrepriseBloc;

  String _name;
  String _email;
  String _tel;
  String _picture;
  String _pathPicture;

  // ignore: unused_element
  FirebaseEntrepriseRepository get _entrepriseRepository =>
      widget._entrepriseRepository;
  Entreprise get editingEnt => widget._entreprise;

  void _openFileExplorer() async {
    try {
      _pathPicture = null;
      _pathPicture = await FilePicker.getFilePath(
        type: FileType.image,
      );
    } on PlatformException catch (e) {
      print('ERROR _openFileExplorer : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _manageEntrepriseBloc = BlocProvider.of<ManageEntrepriseBloc>(context);
  }

  void _onAddEntreprise(Entreprise ent) {
    _manageEntrepriseBloc.add(
      AddEntreprise(ent),
    );
  }

  void _onUpdateEntreprise(Entreprise ent) {
    _manageEntrepriseBloc.add(
      UpdateEntreprise(ent),
    );
  }

  void _onDeleteEntreprise(Entreprise ent) {
    _manageEntrepriseBloc.add(
      DeleteEntreprise(ent),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  );
                }).then((value) {
              if (value == true) {
                _onDeleteEntreprise(editingEnt);
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
      body: BlocListener<ManageEntrepriseBloc, ManageEntrepriseState>(
        listener: (context, state) {
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Impossible d\'effectuer l\'opération. Veuillez réessayer.',
                      ),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red[300],
                ),
              );
          }
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Opération en cours...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Success !'),
                      Icon(Icons.check),
                    ],
                  ),
                  backgroundColor: Colors.green[300],
                ),
              );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ManageEntrepriseBloc, ManageEntrepriseState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
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
                            initialValue:
                                editingEnt != null ? editingEnt.name : '',
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
                              return value.isEmpty
                                  ? 'Veuillez entrer un nom'
                                  : null;
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
                            initialValue:
                                editingEnt != null ? editingEnt.email : '',
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
                            initialValue:
                                editingEnt != null ? editingEnt.tel : '',
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
                                initialValue: editingEnt != null
                                    ? editingEnt.picture
                                    : '',
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
                                onSaved: (newValue) => newValue == ""
                                    ? _picture = "images/unknown_entreprise.png"
                                    : _picture = newValue,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.teal[100],
                                  radius: 25.0,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.file_upload,
                                      color: Colors.teal,
                                      size: 25.0,
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
            );
          },
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
              _onUpdateEntreprise(ent);
            } else {
              ent = Entreprise(
                name: _name,
                email: _email,
                tel: _tel,
                picture: _pathPicture ?? _picture,
              );
              _onAddEntreprise(ent);
            }
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.teal[400],
      ),
    );
  }
}
