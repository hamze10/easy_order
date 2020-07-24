import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:csv/csv.dart';
import 'package:easy_order/src/blocs/manage_product_bloc/manage_product_bloc.dart';
import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';
import 'package:easy_order/src/utils/currency_converter.dart';
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
  final List<String> possibleHeaders = [
    'name',
    'description',
    'picture',
    'currency',
    'price',
    'typeProduct'
  ];

  @override
  void initState() {
    super.initState();
    _manageProductBloc = BlocProvider.of<ManageProductBloc>(context);
  }

  void _onAddMultipleProduct(List<Product> products, Supplier supplier) {
    _manageProductBloc.add(
      AddMultipleProduct(products, supplier),
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

  void _snackbarError(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Veuillez entrez un fichier .csv valide',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red[400],
        duration: Duration(milliseconds: 2000),
      ),
    );
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
      body: BlocListener<ManageProductBloc, ManageProductState>(
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
        child: BlocBuilder<ManageProductBloc, ManageProductState>(
          builder: (context, state) {
            return Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Center(
                            child: GestureDetector(
                              onTap: _openFileExplorer,
                              child: Image.asset(
                                'images/icon_upload_file.png',
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  'Veuillez respectez la structure suivante : ',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 2.0,
                                      bottom: 8.0),
                                  child: Text(
                                    'name | description | picture | currency | price | typeProduct',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  '· picture est facultatif.',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_pathFile == null || _pathFile.isEmpty) {
                        _snackbarError(context);
                      } else {
                        final input = File(_pathFile).openRead();
                        final fields = await input
                            .transform(utf8.decoder)
                            .transform(new CsvToListConverter())
                            .toList();
                        final headers = fields[0].single.toString().split(";");
                        if (!ListEquality().equals(possibleHeaders, headers))
                          return _snackbarError(context);
                        List<Product> myProducts = [];
                        for (List<dynamic> field in fields.skip(1)) {
                          List<String> splitting;
                          try {
                            splitting = field.single.toString().split(";");
                          } catch (e) {
                            return _snackbarError(context);
                          }
                          if (splitting.length != possibleHeaders.length) {
                            return _snackbarError(context);
                          }
                          Product prod = Product(
                            name: splitting[0],
                            description: splitting[1],
                            picture: splitting[2].isNotEmpty
                                ? splitting[2]
                                : 'images/unknown_product.png',
                            currency: CurrencyConvertor.toCurrency(
                                splitting[3].isNotEmpty ? splitting[3] : '€'),
                            price: double.parse(splitting[4]),
                            typeProduct: splitting[5].isNotEmpty
                                ? splitting[5]
                                : 'autre',
                          );
                          myProducts.add(prod);
                        }
                        _onAddMultipleProduct(myProducts, editingProd.supplier);
                      }
                    },
                    child: Container(
                      color: Colors.red[300],
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
            );
          },
        ),
      ),
    );
  }
}
