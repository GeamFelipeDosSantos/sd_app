import "dart:convert";

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Util{

  static AppBar? appBar;

  ///Decodifica texto de base 64
  String decodificarBase64(String texto) {

    String textoSaida = texto.replaceAll('-', '+').replaceAll('_', '/');

    switch (textoSaida.length % 4) {

      case 0:
        break;
      case 2: textoSaida += '==';
      break;
      case 3: textoSaida += '=';
      break;
      default: throw Exception('Texto de base64url ilegal!"');

    }

    return utf8.decode(base64Url.decode(textoSaida));
  }


  static showProgressDialog(BuildContext context, String title, String conteudo) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                title,
                style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Flexible(
                      flex: 8,
                      child: Text(
                        conteudo,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }


}