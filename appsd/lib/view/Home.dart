import 'dart:convert';
import 'dart:io';

import 'package:appsd/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'BuscarRegistros.dart';
import 'CriarAtualizarRegistro.dart';
import 'Sobre.dart';





class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    var appBar;

    void hideStatusBar(){
        if(Platform.isAndroid) {
            SystemChrome.setEnabledSystemUIOverlays([]);
            statusBarColor: Colors.white;

        }
    }


    void hideNavigationBar(){
        if(Platform.isAndroid) {
            //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
            //SystemChrome.setEnabledSystemUIOverlays([]);

        }
    }


    void changeStatusBar(){
        if(Platform.isAndroid) {
            //SystemChrome.setEnabledSystemUIOverlays([]);
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.yellow[300],
                systemNavigationBarColor: Colors.yellow[300],

            statusBarIconBrightness: Brightness.dark, // ícones da barra superior
                systemNavigationBarIconBrightness: Brightness.dark,
            ));

        }
    }

    void ropllbackStatusBar(){
        if(Platform.isAndroid) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
                // statusBarColor: Colors.black38,
                //systemNavigationBarColor: Colors.orange
            ));
        }
    }

    @override
    void initState() {
        setState(() {
            print("Setar valor para appbar");
            Util.appBar = appBar;
        });
        // hideNavigationBar();
        changeStatusBar();
        _carregarDadosHome();
        super.initState();

    }

    int _indiceAtual = 0;
    String _resultado = "";


    _escolhaMenuItem(String itemEscolhido) {
        switch (itemEscolhido) {
            case "Configurações":
                Navigator.pushNamed(context, "/configuracoes");
                break;
            case "Deslogar":
            //_deslogarUsuario();
                break;
        }

    }

    List<Widget> telas = [];

    List<BottomNavigationBarItem> menus = [ ];

    _carregarDadosHome() {

        setState(() {
            Util.appBar = appBar;
        });



        bool menuBaixaSA = false;
        bool menuSobre = false;
        bool menuConfiguracoes = false;



                telas.add(BuscarRegistros());
                menus.add(BottomNavigationBarItem(
                    //backgroundColor: Colors.orange,
                    title: Text("Pesquisar"),
                    icon: Icon(Icons.manage_search)));

                menuConfiguracoes = true;
                telas.add(CriarAtualizarRegistro(registro: null));
                menus.add(BottomNavigationBarItem(
                    //backgroundColor: Colors.orange,
                    title: Text("Registar"),
                    icon: Icon(Icons.mode)));

                menuSobre = true;
                telas.add(Sobre());
                menus.add(BottomNavigationBarItem(
                    //backgroundColor: Colors.orange,
                    title: Text("Sobre"),
                    icon: Icon(Icons.assignment_late)));






    }



    @override
    Widget build(BuildContext context) {
        List<String> itensMenu = ["Configurações", "Sair"];

        return Scaffold(
            appBar: appBar = AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.yellow[300],
                title: Text("BusLog", style: TextStyle(color: Colors.black)),
                actions: <Widget>[
                  /*  PopupMenuButton<String>(
                        onSelected: _escolhaMenuItem,
                        icon: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                        ),
                        itemBuilder: (context) {
                            return itensMenu.map((String item) {
                                return PopupMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                );
                            }).toList();
                        },
                    )*/
                ],
            ),
            body: Container(
                padding: EdgeInsets.all(0),
                child: telas
                [_indiceAtual],
            ),
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.yellow[300],
                showUnselectedLabels: false,
                showSelectedLabels: false,
                iconSize: 30,
                currentIndex: _indiceAtual,
                onTap: (indice) {
                    setState(() {
                        _indiceAtual = indice;
                    });
                },
                type: BottomNavigationBarType.fixed,
                fixedColor: Colors.black,
                items: menus
            ),
        );
    }
}
