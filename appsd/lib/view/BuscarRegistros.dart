import 'dart:io';
import 'package:appsd/model/Registro.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../controller/RegistroController.dart';
import 'CriarAtualizarRegistro.dart';

class BuscarRegistros extends StatefulWidget {
  @override
  _BuscarRegistrosState createState() => _BuscarRegistrosState();
}

class _BuscarRegistrosState extends State<BuscarRegistros> {
  late FocusNode myFocusNode;
  TextEditingController _controllerPesquisar = TextEditingController(text: "");

  List<Registro> _registros = [];
  static int _numItems = 10;
  List<bool> _selectedRegistro = List<bool>.generate(_numItems, (index) => false);
  String _mensagemContador = " ";
  late SnackBar _snackBar;

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
      //SystemChrome.setEnabledSystemUIOverlays([]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.yellow[300],
        systemNavigationBarColor: Colors.yellow[300],

        statusBarIconBrightness: Brightness.dark, // ícones da barra superior
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
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

  Future<List<Registro>> _buscarRegistros() async {
    setState(() {
      _mensagemContador = "";
    });

    List<Registro> registros = [];

    if (_controllerPesquisar.text != "") {
      registros =
          await RegistroController().listarRegistros(_controllerPesquisar.text);

      setState(() {
        _registros = registros;
        _selectedRegistro =
            List<bool>.generate(_registros.length, (index) => false);
        _mensagemContador =
            "Resultado(s) obtido(s): " + _registros.length.toString();
        //print("tamanho da lista de sa");
        //print(registros.length);
      });
    } else {
      setState(() {
        _mensagemContador = " ";
        _registros = registros;
        _snackBar = SnackBar(
          backgroundColor: Colors.redAccent[200],
          content:
              Text('Digite algo no campo "Pesquisar" para buscar registros!'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // código para desfazer a ação!
            },
          ),
        );
        // Encontra o Scaffold na árvore de widgets
        // e o usa para exibir o SnackBar!
        Scaffold.of(context).showSnackBar(_snackBar);
      });
    }

    return registros;
  }

  Widget? _gerarFeedbackUsuario() {
    Widget? componente;

    if (_mensagemContador == "") {
      return new /*CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightGreen));*/
          LinearProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),
        value: null,
      );
    }

    if (_mensagemContador != "" && _mensagemContador != " ") {
      return Text(
        _mensagemContador,
        style: TextStyle(color: Colors.black54, fontSize: 20),
      );
    }

    if (_mensagemContador == " ") {
      return null;
    }

    return componente;
  }

  _atualizarRegistro(index) {
    Registro registro = _registros[index];

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CriarAtualizarRegistro(registro: registro)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: LayoutBuilder(builder: (_, constraints) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            height: 70,
                            color: Colors.yellow[300],
                            //.withOpacity(0.3),
                            child: Row(children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 8, 3, 8),
                                  child: TextField(
                                    controller: _controllerPesquisar,
                                    autofocus: false,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(fontSize: 20),
                                    decoration: InputDecoration(
                                      // icon: Icon(Icons.search, color: Colors.blueAccent),

                                      contentPadding:
                                          EdgeInsets.fromLTRB(16, 16, 1, 16),
                                      hintText: "Pesquisar por linha",
                                      //labelText: "Pesquisar",
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelStyle: new TextStyle(
                                        color: Colors.yellowAccent,
                                      ),
                                      //border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(3, 8, 6, 8),
                                  child: RaisedButton(
                                      splashColor: Colors.white,
                                      elevation: 5,
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                      color: Colors.yellowAccent,
                                      padding:
                                          EdgeInsets.fromLTRB(25, 16, 32, 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      onPressed: () {
                                        _buscarRegistros();
                                        myFocusNode
                                            .requestFocus(new FocusNode());
                                      }),
                                ),
                              )
                            ])),
                        Padding(
                          padding: EdgeInsets.only(top: 1, bottom: 0),
                          child: Center(
                            child: _gerarFeedbackUsuario(),
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight - ((_mensagemContador == " ")? 71: 90),
                          child: SingleChildScrollView(
                            child: DataTable(
                              //showBottomBorder: true,
                              dataRowHeight: 130,
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                      'Marcar - Desmarcar todos os registros'),
                                ),
                              ],

                              rows: List<DataRow>.generate(
                                _registros.length,
                                //_listaGruposAcesso.length,
                                (index) => DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    // All rows will have the same selected color.
                                    if (states.contains(MaterialState.selected))
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.08);
                                    // Even rows will have a grey color.
                                    if (index % 2 == 0)
                                      return Colors.yellowAccent
                                          .withOpacity(0.3);
                                    return Colors
                                        .yellow; // Use default value for other states and odd rows.
                                  }),
                                  cells: [
                                    DataCell(Text('\nNº Registro.: ' +
                                        _registros[index].id.toString() +
                                        '\nDesc. Problema: ' +
                                        _registros[index]
                                            .descricaoProblema!
                                            .trim() +
                                        '\nCidade: ' +
                                        _registros[index].cidade.toString() +
                                        '\nLinha: ' +
                                        _registros[index].linha.toString() +
                                        '\nHorário linha: ' +
                                        _registros[index]
                                            .horarioLinha
                                            .toString() +
                                        '\nData Registro: ' +
                                        _registros[index]
                                            .dtRegistro
                                            .toString() +
                                        '\nData Resolução: ' +
                                        _registros[index]
                                            .dtResolucao
                                            .toString()))
                                  ],
                                  selected: _selectedRegistro[index],
                                  onSelectChanged: (bool? value) {
                                    _atualizarRegistro(index);
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      ]);
                })))
      ])),

    );
  }
}
