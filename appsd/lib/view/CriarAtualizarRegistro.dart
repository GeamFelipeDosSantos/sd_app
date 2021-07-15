import 'dart:async';
import 'dart:io';
import 'package:appsd/controller/RegistroController.dart';
import 'package:appsd/model/Registro.dart';
import 'package:appsd/util/Util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class CriarAtualizarRegistro extends StatefulWidget {
  final Registro? registro;

  CriarAtualizarRegistro({Key? key, this.registro}) : super(key: key);

  @override
  _CriarAtualizarRegistroState createState() => _CriarAtualizarRegistroState();
}

class _CriarAtualizarRegistroState extends State<CriarAtualizarRegistro> {
  TextEditingController _controllerDescricao = TextEditingController(text: "");
  TextEditingController _controllerCidade = TextEditingController(text: "");
  TextEditingController _controllerLinha = TextEditingController(text: "");
  TextEditingController _controllerHorario = TextEditingController(text: "");
  TextEditingController _controllerDtRegistro = TextEditingController(text: "");
  TextEditingController _controllerDtSolucao = TextEditingController(text: "");
  String _mensagemErro = " ";
  late SnackBar _snackBar;

  @override
  void initState() {
    changeStatusBar();
    super.initState();

    _iniciarTela();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
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

  void _iniciarTela() {
    if (null != widget.registro) {
      setState(() {
        _controllerDescricao.text = widget.registro!.descricaoProblema!;
        _controllerCidade.text = widget.registro!.cidade!;
        _controllerLinha.text = widget.registro!.linha!;
        _controllerHorario.text = widget.registro!.horarioLinha!;
        _controllerDtRegistro.text = widget.registro!.dtRegistro!;
        //_controllerDtSolucao.text = (null == widget.registro!.dtResolucao!) ?"":widget.registro!.dtResolucao!;
      });
    }
  }

  //-----------------------------

  bool loading = false;

  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  Widget? _gerarFeedbackUsuario() {
    return null;
  }

  bool _validarCampos() {
    bool camposCorretamentePreenchidos = true;

    setState(() {
      _mensagemErro = "";
    });

    if (_controllerDescricao.text.isEmpty) {
      setState(() {
        _mensagemErro += "Informe a descrição do problema!\n";
        camposCorretamentePreenchidos = false;
      });
    }

    if (_controllerCidade.text.isEmpty) {
      setState(() {
        _mensagemErro += "Informe a cidade!\n";
        camposCorretamentePreenchidos = false;
      });
    }

    if (_controllerLinha.text.isEmpty) {
      setState(() {
        _mensagemErro += "Informe a linha!\n";
        camposCorretamentePreenchidos = false;
      });
    }

    if (_controllerHorario.text.isEmpty) {
      setState(() {
        _mensagemErro += "Informe o horário!\n";
        camposCorretamentePreenchidos = false;
      });
    }

    if (_controllerDtRegistro.text.isEmpty) {
      setState(() {
        _mensagemErro += "Informe a data!\n";
        camposCorretamentePreenchidos = false;
      });
    }

    print(_mensagemErro);

    return camposCorretamentePreenchidos;
  }

  _salvarRegistro() {
    _salvar();
  }

  _salvar() async {
    String mensagemFeedback = "Atualizando registro...";
    if (_validarCampos()) {
      if (widget.registro != null) {
        try {
          Registro registro = new Registro.opcionalComId(
              widget.registro!.id,
              _controllerDescricao.text,
              _controllerCidade.text,
              _controllerLinha.text,
              _controllerHorario.text,
              "F",
              _controllerDtRegistro.text,
              _controllerDtSolucao.text);

          Util.showProgressDialog(
              this.context, mensagemFeedback, mensagemFeedback);

          String statusPut =
              await RegistroController().atualizarRegistro(registro);

          setState(() {
            mensagemFeedback = "Atualizando registro!";
          });

          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Registro atualizado!"),
                  content: new Text("Registro atualizado com sucesso!"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    )
                  ]);
            },
          );
        } on SocketException {
          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Não foi possível atualizar este registro!"),
                  content: new Text(
                    'Não recebemos resposta do servidor!\nPor favor, verifique sua conexão com a internet e tente novamente mais tarde!',
                    style: TextStyle(color: Colors.red),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    )
                  ]);
            },
          );
        } on TimeoutException {
          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Não foi possível atualizar este registro!"),
                  content: new Text(
                    'Não recebemos resposta do servidor!\nPor favor, tente novamente mais tarde!',
                    style: TextStyle(color: Colors.red),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    )
                  ]);
            },
          );
        } catch (e) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Não foi possível atualizar este registro!"),
                  content: new Text(
                    e.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    )
                  ]);
            },
          );
        }
      } else {
        //Salvar nova funcionalidade

        try {
          Util.showProgressDialog(
              this.context, "Salvar registro!", "Salvando registro...");
          Registro registro = new Registro.opcional(
              _controllerDescricao.text,
              _controllerCidade.text,
              _controllerLinha.text,
              _controllerHorario.text,
              "F",
              _controllerDtRegistro.text,
              null);

          String statusPost =
              await RegistroController().salvarRegistros(registro);

          Navigator.of(context).popUntil((route) => route.isFirst);
          if (statusPost == '201') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: new Text("Novo registro criado!"),
                    content: new Text("Registro criado com sucesso!"),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("Ok"),
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      )
                    ]);
              },
            );
          }
        } on SocketException {
          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Não foi possível salvar este registro!"),
                  content: new Text(
                    'Não recebemos resposta do servidor!\nPor favor, verifique sua conexão com a internet e tente novamente mais tarde!',
                    style: TextStyle(color: Colors.red),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    )
                  ]);
            },
          );
        } on TimeoutException {
          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Não foi possível salvar este registro!"),
                  content: new Text(
                    'Não recebemos resposta do servidor!\nPor favor, tente novamente mais tarde!',
                    style: TextStyle(color: Colors.red),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    )
                  ]);
            },
          );
        } catch (e) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Não foi possível salvar este registro!"),
                  content: new Text(
                    e.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    )
                  ]);
            },
          );
        }
      }
    } else {
      setState(() {
        //_mensagemContador = " ";

        _snackBar = SnackBar(
          backgroundColor: Colors.redAccent[200],
          content: Text('Preencha os campos corretamente!\n' + _mensagemErro),
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
      /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Preencha os campos corretamente!"),
              content: new Text(_mensagemErro,style: TextStyle(
                  color: Colors.red
              ),),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                )
              ]);
        },
      );*/
    }
  }

  Widget? _widgetsAtualizar() {
    return TextField(
      controller: _controllerDtSolucao,
      autofocus: false,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        // icon: Icon(Icons.search, color: Colors.blueAccent),

        contentPadding: EdgeInsets.fromLTRB(16, 16, 1, 16),
        hintText: "Dt. solução",
        labelText: "Dt. solução",
        filled: true,
        fillColor: Colors.white,
        labelStyle: new TextStyle(
          color: Colors.grey[800],
        ),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 45, 0, 10),
            child: Text(
                (null != widget.registro)
                    ? "Atualizar registro"
                    : "Criar registro",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 3, 8),
            child: TextField(
              controller: _controllerDescricao,
              autofocus: false,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                // icon: Icon(Icons.search, color: Colors.blueAccent),

                contentPadding: EdgeInsets.fromLTRB(16, 16, 1, 16),
                hintText: "Descrição problema",
                labelText: "Descrição Problema",
                filled: true,
                fillColor: Colors.white,
                labelStyle: new TextStyle(
                  color: Colors.grey[800],
                ),
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 3, 8),
            child: TextField(
              controller: _controllerCidade,
              autofocus: false,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                // icon: Icon(Icons.search, color: Colors.blueAccent),

                contentPadding: EdgeInsets.fromLTRB(16, 16, 1, 16),
                hintText: "Cidade",
                labelText: "Cidade",
                filled: true,
                fillColor: Colors.white,
                labelStyle: new TextStyle(
                  color: Colors.grey[800],
                ),
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 3, 8),
            child: TextField(
              controller: _controllerLinha,
              autofocus: false,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                // icon: Icon(Icons.search, color: Colors.blueAccent),

                contentPadding: EdgeInsets.fromLTRB(16, 16, 1, 16),
                hintText: "Linha",
                labelText: "Linha",
                filled: true,
                fillColor: Colors.white,
                labelStyle: new TextStyle(
                  color: Colors.grey[800],
                ),
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 3, 8),
            child: TextField(
              controller: _controllerHorario,
              autofocus: false,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                // icon: Icon(Icons.search, color: Colors.blueAccent),

                contentPadding: EdgeInsets.fromLTRB(16, 16, 1, 16),
                hintText: "Horário",
                labelText: "Horário",
                filled: true,
                fillColor: Colors.white,
                labelStyle: new TextStyle(
                  color: Colors.grey[800],
                ),
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 3, 8),
            child: TextField(
              controller: _controllerDtRegistro,
              autofocus: false,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                // icon: Icon(Icons.search, color: Colors.blueAccent),

                contentPadding: EdgeInsets.fromLTRB(16, 16, 1, 16),
                hintText: "Dt. Registro",
                labelText: "Dt. Registro",
                filled: true,
                fillColor: Colors.white,
                labelStyle: new TextStyle(
                  color: Colors.grey[800],
                ),
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 3, 8),
            child: (null != widget.registro) ? _widgetsAtualizar() : null,
          ),
        ]))),
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.black12,
          elevation: 20,
          child: Icon(Icons.save_rounded, color: Colors.black),
          backgroundColor: Colors.yellowAccent,
          onPressed: () => _salvarRegistro(),
        ));
  }
}
