import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextControler = TextEditingController();
  final TextEditingController _confirmEmailTextControler =
      TextEditingController();
  final TextEditingController _passwordTextControler = TextEditingController();
  final TextEditingController _confirmPasswordTextControler =
      TextEditingController();
  // final Map<String, dynamic> _formData = {
  //   'userEmail': null,
  //   'userPassword': null,
  //   'acceptTerms': false,
  // };

  Widget _buildEmailTextField() {
    return TextField(
      // onSaved: (String value) {
      //   _formData['userEmail'] = value;
      // },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
        filled: true,
        fillColor: Colors.white,
      ),
      controller: _emailTextControler,
      // validator: (String value) {
      //   if (value.isEmpty ||
      //       !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
      //           .hasMatch(value)) {
      //     print('Por favor ingrese un correo electrónico válido');
      //     return 'Por favor ingrese un correo electrónico válido';
      //   }
      // },
    );
  }

  // Widget _buildEmailConfirmTextField() {
  //   return TextField(
  //     // onSaved: (String value) {
  //     //   _formData['userEmail'] = value;
  //     // },
  //     keyboardType: TextInputType.emailAddress,
  //     decoration: InputDecoration(
  //       labelText: 'Confirmar correo eletrónico',
  //       filled: true,
  //       fillColor: Colors.white,
  //     ),
  //     // validator: (String value) {
  //     //   if (_emailTextControler.text != value) {
  //     //     print('Los correos electrónicos ingresados no coinciden');
  //     //     return 'Los correos electrónicos ingresados no coinciden';
  //     //   }
  //     // },
  //   );
  // }

  // Widget _buildPasswordTextField() {
  //   return TextField(
  //     // onSaved: (String value) {
  //     //   _formData['userPassword'] = value;
  //     // },
  //     obscureText: true,
  //     decoration: InputDecoration(
  //       labelText: 'Contraseña',
  //       filled: true,
  //       fillColor: Colors.white,
  //     ),
  //     controller: _passwordTextControler,
  //     // validator: (String value) {
  //     //   if (value.isEmpty || value.length < 6) {
  //     //     print('Ingrese una contraseña de mínimo 6 caracteres');
  //     //     return 'Ingrese una contraseña de mínimo 6 caracteres';
  //     //   }
  //     // },
  //   );
  // }

  Widget _buildPasswordConfirmTextField() {
    return TextField(
      // onSaved: (String value) {
      //   _formData['userPassword'] = value;
      // },
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirmar contraseña',
        filled: true,
        fillColor: Colors.white,
      ),
      // validator: (String value) {
      //   if (_passwordTextControler.text != value) {
      //     print('Las contraseñas ingresadas no coinciden');
      //     return 'Las contraseñas ingresadas no coinciden';
      //   }
      // },
    );
  }

  String addUserLoginData = r'''
      mutation AddUserLoginData($userEmail: String!, $userPassword: String!){
        addUserLoginData(userEmail: $userEmail, userPassword: $userPassword){
          id
          userEmail
          userPassword
        }
      }
    ''';
  // .replaceAll('\n', '');

  @override
  Widget build(BuildContext context) {
    final double deviceWith = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWith > 550.0 ? 500.0 : deviceWith * 0.85;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Bienvenido',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: deviceWith * 0.060,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Regístrate',
                    style: TextStyle(
                      fontSize: deviceWith * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Inicia Sesión',
                    style: TextStyle(
                      fontSize: deviceWith * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Mutation(
                  options: MutationOptions(
                    documentNode: gql(addUserLoginData),
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
                          width: targetWidth,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Correo electrónico',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: _emailTextControler,
                              ),
                              SizedBox(height: 10.0),
                              TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Confirma el correo electrónico',
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  controller: _confirmEmailTextControler),
                              SizedBox(height: 10.0),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: _passwordTextControler,
                              ),
                              SizedBox(height: 10.0),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Confirmar contraseña',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              FlatButton(
                                color: Theme.of(context).buttonColor,
                                child: Text(
                                  'Enviar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWith * 0.040,
                                  ),
                                ),
                                onPressed: () => {
                                  runMutation(
                                    {
                                      'userEmail': _emailTextControler.text,
                                      'userPassword':
                                          _passwordTextControler.text
                                    },
                                  ),
                                  Navigator.pushReplacementNamed(
                                      context, '/reports')
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: targetWidth,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: _emailTextControler,
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          controller: _passwordTextControler,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FlatButton(
                          color: Theme.of(context).buttonColor,
                          child: Text(
                            'Ingresar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: deviceWith * 0.040,
                            ),
                          ),
                          onPressed: () => {
                            Navigator.pushReplacementNamed(context, '/reports')
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
