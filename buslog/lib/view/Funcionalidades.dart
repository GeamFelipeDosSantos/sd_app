import 'dart:ui';
import 'package:buslog/controller/FuncionalidadeController.dart';
import 'package:buslog/model/Funcionalidade.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';


class Funcionalidades extends StatefulWidget {
  @override
  _FuncionalidadesState createState() => _FuncionalidadesState();
}

class _FuncionalidadesState extends State<Funcionalidades> {


  List<Funcionalidade> _listaFuncionalidades = null;


  @override
  void initState() {
    super.initState();
    hideNavigationBar();
    changeStatusBar();
    _listarFuncionalidades();
    //changeNavigationBar();

  }


  void hideStatusBar(){
    if(Platform.isAndroid) {

      SystemChrome.setEnabledSystemUIOverlays([]);

    }
  }
  void hideNavigationBar(){
    if(Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        //statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.blueAccent,

      ));
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);


    }
  }
  void changeStatusBar(){
    if(Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        //systemNavigationBarColor: Colors.white,
      ));

    }
  }

  void changeNavigationBar(){
    if(Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        //statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.blueAccent,
        
      ));

    }
  }

  void ropllbackStatusBar(){
    if(Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.blueAccent,
        //systemNavigationBarColor: Colors.orange
      ));
    }
  }




  Future<List<Funcionalidade>> _listarFuncionalidades() async {
    List<Funcionalidade> funcionalidades;


      funcionalidades = await FuncionalidadeController().listarFuncionalidades();
    
      return funcionalidades;
  }

   navegarParaFuncionalidades(Funcionalidade funcionalidade) async {
    if(funcionalidade == null) {

      /*Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroFuncionalidade(funcionalidade: funcionalidade)));*/

    }else{

     /* Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CadastroFuncionalidade(funcionalidade: funcionalidade)));*/

      var result;
      var resultado = null;// await Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroFuncionalidade(funcionalidade: funcionalidade)));;
      var listaFuncionalidades = await _listarFuncionalidades();

      setState(()  {

        result = resultado;

        if (result.toString() == 'S') {
          _listaFuncionalidades = listaFuncionalidades;
        }
      });


    }
  }

  FloatingActionButton criarBotaoAdicionarFuncionalidade()   {

    FloatingActionButton botaoAdicionarFuncionalidade;


    botaoAdicionarFuncionalidade = FloatingActionButton(
      onPressed: () {
        navegarParaFuncionalidades(null);
      },
      child: Icon(Icons.add,color: Colors.white),
      backgroundColor: Colors.blueAccent,
    );

    return botaoAdicionarFuncionalidade;
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
          title: Text("Funcionalidades",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
          iconTheme: IconThemeData(color: Colors.white)),
      body: Center(
          child: FutureBuilder<List<dynamic>>(
            future: _listaFuncionalidades != null ? _listaFuncionalidades : _listarFuncionalidades(),
            builder:  (BuildContext context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:

                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
                  );
                  break;
                case ConnectionState.active:

                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {

                    List<Funcionalidade> funcionalidadesLista = snapshot.data;
                    if (snapshot.data.length >= 1 &&
                        funcionalidadesLista[0].nomeFuncionalidade != "") {
                      return ListView.builder(
                        itemCount: funcionalidadesLista.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                title: Text( funcionalidadesLista[index].nomeFuncionalidade,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                        ),
                                
                              onTap: () {
                                navegarParaFuncionalidades(funcionalidadesLista[index]);

                              },
                              ),
                              Divider(), //                           <-- Divider
                            ],
                          );
                        },
                      );

                    } else {
                      return Center(
                        child: Text("Não existem funcionalidades, ou não foi possível receber os dados do servidor\nTente novamente mais tarde!"),
                      );
                    }
                  }else {
                    return Center(
                      child: Text("Não existem funcionalidades, ou não foi possível receber os dados do servidor\nTente novamente mais tarde!"),
                    );
                  }
                  break;
              }

              return new ListView.separated();

            },

          )
      ),
      floatingActionButton: criarBotaoAdicionarFuncionalidade(),

    );


  }
}