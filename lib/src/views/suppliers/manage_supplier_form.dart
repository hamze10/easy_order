import 'package:easy_order/src/blocs/manage_supplier_bloc/manage_supplier_bloc.dart';
import 'package:easy_order/src/models/suppliers/manageSupplierArguments.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';
import 'package:easy_order/src/repositories/supplier/firebase_supplier_repository.dart';
import 'package:easy_order/src/utils/validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageSupplierForm extends StatefulWidget {
  final FirebaseSupplierRepository _supplierRepository;
  final ManageSupplierArguments _manageSupplierArguments;

  ManageSupplierForm({
    Key key,
    @required FirebaseSupplierRepository supplierRepository,
    @required ManageSupplierArguments manageSupplierArguments,
  })  : assert(supplierRepository != null && manageSupplierArguments != null),
        _supplierRepository = supplierRepository,
        _manageSupplierArguments = manageSupplierArguments,
        super(key: key);

  @override
  _ManageSupplierFormState createState() => _ManageSupplierFormState();
}

class _ManageSupplierFormState extends State<ManageSupplierForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ManageSupplierBloc _manageSupplierBloc;

  String _name;
  String _email;
  String _tel;
  String _picture;
  String _pathPicture;

  FirebaseSupplierRepository get _supplierRepository =>
      widget._supplierRepository;
  ManageSupplierArguments get editingSupp => widget._manageSupplierArguments;

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
    _manageSupplierBloc = BlocProvider.of<ManageSupplierBloc>(context);
  }

  void _onAddSupplier(ManageSupplierArguments msa) {
    _manageSupplierBloc.add(
      AddSupplier(msa.supplier, msa.entreprise),
    );
  }

  void _onUpdateSupplier(ManageSupplierArguments msa) {
    _manageSupplierBloc.add(
      UpdateSupplier(msa.supplier),
    );
  }

  void _onDeleteSupplier(ManageSupplierArguments msa) {
    _manageSupplierBloc.add(
      DeleteSupplier(msa.supplier, msa.entreprise),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (editingSupp.supplier != null) {
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
                        "Voulez-vous vraiment supprimer ce fournisseur ? "),
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
                _onDeleteSupplier(editingSupp);
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
          editingSupp.supplier != null
              ? 'Modifier un fournisseur'
              : 'Ajouter un fournisseur',
        ),
      ),
      body: BlocListener<ManageSupplierBloc, ManageSupplierState>(
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
                        'Impossible d\'effectuer l\'opération.',
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
        child: BlocBuilder<ManageSupplierBloc, ManageSupplierState>(
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
                            initialValue: editingSupp.supplier != null
                                ? editingSupp.supplier.name
                                : '',
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
                            initialValue: editingSupp.supplier != null
                                ? editingSupp.supplier.email
                                : '',
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
                            initialValue: editingSupp.supplier != null
                                ? editingSupp.supplier.tel
                                : '',
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
                                initialValue: editingSupp.supplier != null
                                    ? editingSupp.supplier.picture
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
                                    ? _picture = "images/unknown_supplier.png"
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
            ManageSupplierArguments msa;
            if (editingSupp.supplier != null) {
              Supplier supp = Supplier(
                id: editingSupp.supplier.id,
                email: _email,
                name: _name,
                tel: _tel,
                products: editingSupp.supplier.products,
                picture: _pathPicture ?? _picture,
              );
              msa = ManageSupplierArguments(supp, editingSupp.entreprise);
              _onUpdateSupplier(msa);
            } else {
              Supplier supp = Supplier(
                email: _email,
                name: _name,
                tel: _tel,
                products: const [],
                picture: _pathPicture ?? _picture,
              );
              msa = ManageSupplierArguments(supp, editingSupp.entreprise);
              _onAddSupplier(msa);
            }
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.red[400],
      ),
    );
  }
}
