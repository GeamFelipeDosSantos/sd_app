import 'package:ADMob/view/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        //onGenerateRoute: RouteGenerator.generateRoute,

        theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.dark,
          primarySwatch: Colors.yellow[300],
          primaryColor: Colors.yellow[100],
          //accentColor: Colors.cyan[600],
          // Define the default font family.
          fontFamily: 'Montserrat',
          visualDensity: VisualDensity.adaptivePlatformDensity,

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          /*textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),*/
        )

    ));
  });
}
/*
void main()   => runApp(MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,

    theme: ThemeData(
      // Define the default brightness and colors.
      //brightness: Brightness.dark,
      primarySwatch: Colors.lightBlue,
      primaryColor: Colors.blueAccent,
      //accentColor: Colors.cyan[600],
      // Define the default font family.
      fontFamily: 'Montserrat',

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      /*textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),*/
    )

));*/
