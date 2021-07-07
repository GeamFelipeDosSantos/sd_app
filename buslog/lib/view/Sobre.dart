import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';



class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {


  @override
  void initState() {

    changeStatusBar();

    super.initState();

  }

  void hideStatusBar(){
    if(Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      statusBarColor: Colors.white;

    }
  }


  void hideNavigationBar(){
    if(Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      //SystemChrome.setEnabledSystemUIOverlays([]);

    }
  }


  void changeStatusBar(){
    if(Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.blueAccent,
      ));

    }
  }

  void ropllbackStatusBar() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(

      ));
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: // Center(
      //child:
      Column(/*   _atualizarTextoNomesPlantonistas(
                                    equipeAtual.id);
                              },*/
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Padding(
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: new Text(
        "Sobre:\nBusLog\nVersão 1.0\nTrabalho de sistemas distribuídos\n",
        style: new TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    ]
      ),

    );
  }
}
