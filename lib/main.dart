import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reporte_ciudadano_app/pages/authentication_page.dart';
import 'package:reporte_ciudadano_app/pages/reports_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: 'http://958d787e9a49.ngrok.io/graphql?',
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Reportes ciudadanos',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            buttonColor: Colors.blue[400],

            // visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routes: {
            '/': (BuildContext context) => AuthenticationPage(),
            '/reports': (BuildContext context) => ReportsPage(),
          },
          // home: Scaffold(),
        ),
      ),
    );
  }
}
