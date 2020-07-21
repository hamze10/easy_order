import 'package:easy_order/src/blocs/manage_product_bloc/manage_product_bloc.dart';
import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CSVProductForm extends StatefulWidget {
  final ManageProductArguments _manageProductArguments;

  CSVProductForm(this._manageProductArguments);

  @override
  _CSVProductFormState createState() => _CSVProductFormState();
}

class _CSVProductFormState extends State<CSVProductForm> {
  ManageProductArguments get editingProd => widget._manageProductArguments;

  String _pathFile;
  ManageProductBloc _manageProductBloc;

  @override
  void initState() {
    super.initState();
    _manageProductBloc = BlocProvider.of<ManageProductBloc>(context);
  }

  void _onAddProduct(ManageProductArguments mpa) {
    _manageProductBloc.add(
      AddProduct(mpa.product, mpa.supplier),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openFileExplorer() async {
    try {
      _pathFile = null;
      _pathFile = await FilePicker.getFilePath(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
    } on PlatformException catch (e) {
      print('ERROR _openFileExplorer : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Upload d\'un fichier .csv',
          style: TextStyle(
            color: Colors.black38,
          ),
        ),
        toolbarOpacity: 0.5,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _openFileExplorer,
                      child: Image.asset('images/icon_upload_file.gif'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Veuilez respectez la structure suivante : ',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 2.0, bottom: 8.0),
                          child: Text(
                            'name | description | picture | currency | price | typeProduit',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '· picture est facultatif.',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "· currency est facultatif et prend par défaut '€', ses autres valeurs sont : MAD, \$ ou £.",
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print("envoyer");
              },
              child: Container(
                color: Colors.blue[300],
                height: 50.0,
                child: Center(
                  child: Text(
                    'Valider votre choix',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
