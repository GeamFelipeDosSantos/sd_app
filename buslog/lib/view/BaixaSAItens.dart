import 'dart:io';
import 'dart:ui';
import 'package:ADMob/model/Registro.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


class BaixaSAItens extends StatefulWidget {
  final List<String> numerosSA;
  final int filial;


  BaixaSAItens({
    Key key,
    @required this.numerosSA,
    @required this.filial
  }) : super(key: key);

  @override
  _BaixaSAItensState createState() => _BaixaSAItensState();
}

class _BaixaSAItensState extends State<BaixaSAItens> {


  final globalKey = GlobalKey<ScaffoldState>();
  FocusNode myFocusNode;
  List<Registro> _solicitacoesArmazem = new List();
  List<TextField> _listaCamposTextoBaixaSA = new List();
  List<TextEditingController> _listaContoladoresDeTextoBaixaSA = new List();
  static int _numItems = 10;
  List<bool> _selectedSA = List<bool>.generate(_numItems, (index) => false);
  String _mensagemFeedback = "";
  SnackBar _snackBar;
  bool _buscandoItensSA = true;
  CameraDescription _cameraDescription;


  @override
  void initState() {
    changeStatusBar();
    super.initState();


    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  void hideNavigationBar() {
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      //SystemChrome.setEnabledSystemUIOverlays([]);

    }
  }

  void changeStatusBar() {
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.blueAccent,
        //systemNavigationBarColor: Colors.blueAccent,
      ));
    }
  }

  void rollbackStatusBar() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
          // statusBarColor: Colors.black38,
          //systemNavigationBarColor: Colors.orange
          ));
    }
  }



  //-----------------------------

  bool loading = false;

  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }


  Widget _gerarFeedbackUsuario() {
    Widget componente;
    if (_buscandoItensSA) {
      return new LinearProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        value: null,
      );
    }

    if (!_buscandoItensSA) {
      return null;
    }
    return componente;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
          title: Text("Baixar SA (Confirmar itens)",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
          iconTheme: IconThemeData(color: Colors.white)),
      body: Container(),
      floatingActionButton: FloatingActionButton(
          splashColor: Colors.white,
          elevation: 20,
          focusNode: myFocusNode,
          child: Icon(Icons.save_alt, color: Colors.white),
          backgroundColor: (_selectedSA.contains(true))
              ? Colors.blueAccent
              : Colors.grey[300],
          onPressed: true //_selectedSA.contains(true)
              ? () {
                  print('baixar');

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: new Text("Baixar S.A.?"),
                          content: new Text(
                            "Confirma a baixa do(s) iten(s) selecionado(s)?",
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("Não"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            new FlatButton(
                              child: new Text("Sim"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                //_baixarSA();
                              },
                            )
                          ]);
                    },
                  );
                }
              : null),
    );
  }
}
