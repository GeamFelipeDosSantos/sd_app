import 'dart:io';
import 'package:buslog/controller/RegistroController.dart';

import 'package:ADMob/view/BaixaSAItens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../controller/RegistroController.dart';

class BaixaSA extends StatefulWidget {
  @override
  _BaixaSAState createState() => _BaixaSAState();
}

enum EnumFiltroGeral { pessoa, sa, requisicao, os }
enum EnumFiltroFilial { portonave, iceport }

class _BaixaSAState extends State<BaixaSA> {

  FocusNode myFocusNode;
  TextEditingController _controllerPesquisar = TextEditingController(text: "");
  EnumFiltroGeral _filtroGeral = EnumFiltroGeral.pessoa;
  EnumFiltroFilial _filtroFilial = EnumFiltroFilial.portonave;
  List<Registro> _registros = new List();
  static int _numItems = 10;
  List<bool> _selectedSA = List<bool>.generate(_numItems, (index) => false);
  bool _acessoFilialPortonave = false;
  int _qtdFiliais = 0;
  String _mensagemContador = " ";
  SnackBar _snackBar;


  @override
  void initState() {
    changeStatusBar();
    super.initState();
    _iniciarTela();
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

  void _iniciarTela() {
    _validarAcessos();
  }

  void _validarAcessos() {
  //  List<dynamic> acessosUsuario = json.decode(Dados.acessosUsuario);

    /*for (int i = 0; i < acessosUsuario.length; i++) {
      if (acessosUsuario[i]["ID_FUNCIONALIDADE"] == 1) {
        if (acessosUsuario[i]["ID_FILIAL"] == 1) {*/
          setState(() {
            _acessoFilialPortonave = true;
            _filtroFilial = EnumFiltroFilial.portonave;
            setState(() {
              _qtdFiliais++;
            });
          });
       /* }
      }*/

     /* if (acessosUsuario[i]["ID_FUNCIONALIDADE"] == 1) {
        if (acessosUsuario[i]["ID_FILIAL"] == 2) {*/
          setState(() {
            if (!_acessoFilialPortonave) {
              _filtroFilial = EnumFiltroFilial.iceport;
            }
            setState(() {
              _qtdFiliais++;
            });
          });
       /* }
      }*/
    //}
  }

  Future<List<Registro>> _buscarSAs() async {
    setState(() {
      _mensagemContador = "";

    });
    List<Registro> registros = new List();

    if (_controllerPesquisar.text != "") {
      int filial = 1;

      if (_filtroFilial == EnumFiltroFilial.iceport) {
        filial = 2;
      }

      if (_filtroGeral == EnumFiltroGeral.pessoa) {
        // print("BUSCANDO POR PESSOA");
        registros = await RegistroController().listarSolicitacoes(filial, _controllerPesquisar.text, "1", false);
      }

      if (_filtroGeral == EnumFiltroGeral.sa) {
        //  print("BUSCANDO POR SA");
        registros = await RegistroController()
            .listarSolicitacoes(filial, _controllerPesquisar.text, "2", false);
      }

      if (_filtroGeral == EnumFiltroGeral.requisicao) {
        //  print("BUSCANDO POR REQUISIÇÃO");
        registros = await RegistroController()
            .listarSolicitacoes(filial, _controllerPesquisar.text, "3", false);
      }

      if (_filtroGeral == EnumFiltroGeral.os) {
        //  print("BUSCANDO POR O.S.");
        registros = await RegistroController()
            .listarSolicitacoes(filial, _controllerPesquisar.text, "4", false);
      }

      setState(() {
        _registros = registros;
        _selectedSA =
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
              Text('Digite algo no campo "Pesquisar" para buscar por S.A.s!'),
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

  Widget _gerarFeedbackUsuario() {

    Widget componente ;

    if (_mensagemContador == "") {
      return new /*CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightGreen));*/
          LinearProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
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

  void _baixarSA() {
    List<String> numerosSA = new List();
   /* if (_selectedSA.contains(true)) {
      List<String> numerosSA = new List();

      for (int i = 0; i < _registros.length; i++) {
        print("SA");
        print(_registros[i].numSa);

        print("SA selecionada");
        print(_selectedSA[i]);

        if (_selectedSA[i]) {
          print(_selectedSA[i]);
          print(_registros[i].numSa);
          numerosSA.add(_registros[i].numSa);
          //GrupoAcessoFilialController().salvarGrupoAcessoFilial(new GrupoAcessoFilial.opcional(widget.grupoAcesso.id_grupo_acesso,_listaFiliais[i].idFilial));
        }
      }
*/
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BaixaSAItens(
                  numerosSA: numerosSA,
                  filial:
                      _filtroFilial == EnumFiltroFilial.portonave ? 1 : 2)));
      //dispose();
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: <Widget>[
        Expanded(
            child: Container(child: LayoutBuilder(builder: (_, constraints) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 70,
                    color: Colors.blueAccent.withOpacity(0.3),
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
                              hintText: "Pesquisar",
                              //labelText: "Pesquisar",
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: new TextStyle(
                                color: Colors.blueAccent,
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
                            elevation: 20,
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              color: Colors.blueAccent,
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              onPressed: () {
                                // print("Buscar SA's!");
                                _buscarSAs();
                                myFocusNode.requestFocus(new FocusNode());
                              }),
                        ),
                      )
                    ])),
                Container(
                  height: 176,
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            focusNode: myFocusNode,
                            title: const Text('Pessoa'),
                            leading: Radio(
                              value: EnumFiltroGeral.pessoa,
                              groupValue: _filtroGeral,
                              onChanged: (EnumFiltroGeral value) {
                                setState(() {
                                  _filtroGeral = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('S.A.'),
                            leading: Radio(
                              value: EnumFiltroGeral.sa,
                              groupValue: _filtroGeral,
                              onChanged: (EnumFiltroGeral value) {
                                setState(() {
                                  _filtroGeral = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text(
                              'Requisição',
                            ),
                            leading: Radio(
                              value: EnumFiltroGeral.requisicao,
                              groupValue: _filtroGeral,
                              onChanged: (EnumFiltroGeral value) {
                                setState(() {
                                  _filtroGeral = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('O.S.'),
                            leading: Radio(
                              value: EnumFiltroGeral.os,
                              groupValue: _filtroGeral,
                              onChanged: (EnumFiltroGeral value) {
                                setState(() {
                                  _filtroGeral = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.blueAccent,
                      height: 20,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: const Text('Portonave'),
                            leading: Radio(
                              value: EnumFiltroFilial.portonave,
                              groupValue: _filtroFilial,
                              onChanged: _qtdFiliais > 1
                                  ? (EnumFiltroFilial value) {
                                      setState(() {
                                        _filtroFilial = value;
                                      });
                                    }
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Iceport'),
                            leading: Radio(
                              value: EnumFiltroFilial.iceport,
                              groupValue: _filtroFilial,
                              onChanged: _qtdFiliais > 1
                                  ? (EnumFiltroFilial value) {
                                      setState(() {
                                        _filtroFilial = value;
                                      });
                                    }
                                  : null,
                            ),
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.blueAccent,
                      height: 20,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1, bottom: 0),
                      child: Center(
                        child: _gerarFeedbackUsuario(),
                      ),
                    ),
                  ]),
                ),
                Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight - 248,
                  child: SingleChildScrollView(
                    child: DataTable(
                      dataRowHeight: 110,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                              'Marcar - Desmarcar todas as solicitações ao armazém'),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        _registros.length,
                        //_listaGruposAcesso.length,
                        (index) => DataRow(
                          color: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            // All rows will have the same selected color.
                            if (states.contains(MaterialState.selected))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            // Even rows will have a grey color.
                            if (index % 2 == 0)
                              return Colors.blueAccent.withOpacity(0.3);
                            return null; // Use default value for other states and odd rows.
                          }),
                          cells: [
                            DataCell(Text('\nS.A.: ' +
                                _registros[index].numSa +
                                '\nSolicitante: ' +
                                _registros[index]
                                    .nomeSolicitante
                                    .trim() +
                                '\nO.S.: ' +
                                _registros[index].numOs +
                                '\nRequisição OBC: ' +
                                _registros[index].requisicao +
                                '\nQtd. Itens: ' +
                                _registros[index]
                                    .qtdItensSa
                                    .toString() +
                                '\n'))
                          ],
                          selected: _selectedSA[index],
                          onSelectChanged: (bool value) {
                            setState(() {
                              _selectedSA[index] = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ]);
        })))
      ])),
      floatingActionButton: FloatingActionButton(
          splashColor: Colors.white,
          elevation: 20,
          child: Icon(Icons.save_alt, color: Colors.white),
          backgroundColor:
              //(_registros.length > 0 && _selectedSA.contains(true))
          //        ?
          Colors.blueAccent,
            //      : Colors.grey[300],
          onPressed: 1 > 0
              ? () {
                  print('baixar');

                  _baixarSA();
                }
              : null),
    );
  }
}
