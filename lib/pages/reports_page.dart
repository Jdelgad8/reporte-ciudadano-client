import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  File _selectedFile;
  final picker = ImagePicker();
  bool _inProcess = false;
  final TextEditingController _reportTitleTextControler =
      TextEditingController();
  final TextEditingController _reportDescriptionTextControler =
      TextEditingController();
  final TextEditingController _categoryIdTextControler =
      TextEditingController();
  String _selectedCategoryId;
  String addReportQuery = r'''
    mutation AddReport(
      $userBasicDataId: ID!,
      $reportCategoryId: ID!,
      $reportDescription: String!,
      $reportTitle: String!,
      $reportConfirmationCount: Int!
    ){
      addReport(
        userBasicDataId: $userBasicDataId,
        reportCategoryId: $reportCategoryId,
        reportDescription:$reportDescription,
        reportTitle: $reportTitle,
        reportConfirmationCount: $reportConfirmationCount
      ){
      id
      reportTitle
      reportDescription
      }
    }
  ''';
  String reportCategoriesQuery = r'''
  query reportcategories{
    reportCategories{
      id
      reportCategory
    }
  }
  ''';

  Widget _buildDrawer(BuildContext context, double deviceWith) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Menú'),
            centerTitle: true,
          ),
          ListTile(
            leading: Icon(
              Icons.report,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Haz un reporte',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: deviceWith * 0.045),
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/reports');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Cerrar sesión',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: deviceWith * 0.045),
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildGetImageWidget(double deviceWith) {
    if (_selectedFile != null) {
      return Container(
        child: Image.file(
          _selectedFile,
          width: deviceWith * 0.8,
          height: deviceWith * 0.8,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.asset(
        "assets/image_placeholder.png",
        width: deviceWith * 0.8,
        height: deviceWith * 0.8,
        fit: BoxFit.cover,
      );
    }
  }

  Future _getImage(ImageSource source, double deviceWith) async {
    this.setState(() {
      _inProcess = true;
    });
    final image = await picker.getImage(source: source);

    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Theme.of(context).primaryColor,
          toolbarTitle: "Recortar la imágen",
          backgroundColor: Colors.white,
        ),
      );
      this.setState(() {
        _selectedFile = File(cropped.path);
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWith = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double targetWidth = deviceWith > 550.0 ? 500.0 : deviceWith * 0.95;
    return Scaffold(
      drawer: _buildDrawer(context, deviceWith),
      appBar: AppBar(
        title: Text(
          'Haz un reporte',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: deviceWith * 0.055),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Mutation(
            options: MutationOptions(
              documentNode: gql(addReportQuery),
              update: (Cache cache, QueryResult result) {
                if (result.hasException) {
                  print(result.exception);
                }
                return cache;
              },
              onCompleted: (dynamic resultData) {
                print(resultData.addUserLoginData.id);

                Navigator.pushReplacementNamed(
                  context,
                  '/reports',
                );
              },
              onError: (OperationException error) {
                showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(error.toString()),
                      actions: <Widget>[
                        SimpleDialogOption(
                          child: const Text('DISMISS'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
            builder: (RunMutation runMutation, QueryResult result) {
              return Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: targetWidth,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    _buildGetImageWidget(deviceWith),
                                    SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: deviceWith * 0.2,
                                          height: deviceWith * 0.1,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                            child: IconButton(
                                              tooltip: 'Añadir desde cámara',
                                              color: Colors.white,
                                              iconSize: 25.0,
                                              onPressed: () {
                                                _getImage(ImageSource.camera,
                                                    deviceWith);
                                              },
                                              icon: Icon(Icons.camera_alt),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          width: deviceWith * 0.2,
                                          height: deviceWith * 0.1,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                            child: IconButton(
                                              tooltip: 'Añadir desde galería',
                                              color: Colors.white,
                                              iconSize: 25.0,
                                              onPressed: () {
                                                _getImage(ImageSource.gallery,
                                                    deviceWith);
                                              },
                                              icon: Icon(Icons.filter),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            (_inProcess)
                                ? Container(
                                    color: Colors.white,
                                    height: deviceHeight * 95,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Center(),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Título del reporte',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: _reportTitleTextControler,
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Descripción del reporte',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: _reportDescriptionTextControler,
                        ),
                        SizedBox(height: 10.0),
                        FlatButton(
                          color: Theme.of(context).buttonColor,
                          child: Text(
                            'Reportar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: deviceWith * 0.040,
                            ),
                          ),
                          onPressed: () => {
                            runMutation(
                              {
                                'userBasicDataId': "",
                                'reportCategoryId': "",
                                'reportTitle': _reportTitleTextControler.text,
                                'reportDescription':
                                    _reportDescriptionTextControler.text,
                                'reportConfirmationCount': 1,
                              },
                            ),
                            Navigator.pushReplacementNamed(context, '/reports')
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
