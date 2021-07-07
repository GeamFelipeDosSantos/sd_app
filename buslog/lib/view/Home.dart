import 'dart:convert';
import 'dart:io';
import 'package:ADMob/util/Dados.dart';
import 'package:ADMob/util/Util.dart';
import 'package:ADMob/view/BaixaSA.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            SystemChrome.setEnabledSystemUIOverlays([]);
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.blueAccent,
                //systemNavigationBarColor: Colors.blueAccent,
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


        List<dynamic> acessosUsuario = json.decode(Dados.acessosUsuario);
        bool menuBaixaSA = false;
        bool menuSobre = false;
        bool menuConfiguracoes = false;



        for (int i = 0; i < acessosUsuario.length; i++) {



            if (acessosUsuario[i]["ID_GRUPO_ACESSO"] == 1
                && !menuBaixaSA ) { //1-Administradores

                menuBaixaSA = true;
                telas.add(BaixaSA());
                menus.add(BottomNavigationBarItem(
                    //backgroundColor: Colors.orange,
                    title: Text("Baixa de SA"),
                    icon: Icon(Icons.save_alt)));

                menuConfiguracoes = true;
                telas.add(BaixaSA());
                menus.add(BottomNavigationBarItem(
                    //backgroundColor: Colors.orange,
                    title: Text("Configurações"),
                    icon: Icon(Icons.settings)));

                menuSobre = true;
                telas.add(Sobre());
                menus.add(BottomNavigationBarItem(
                    //backgroundColor: Colors.orange,
                    title: Text("Sobre"),
                    icon: Icon(Icons.assignment_late)));



            }

            if (acessosUsuario[i]["ID_FUNCIONALIDADE"] == 1
                && !menuBaixaSA ) {//1-Administradores

                menuBaixaSA = true;
                telas.add(BaixaSA());
                menus.add(BottomNavigationBarItem(
                    //backgroundColor: Colors.orange,
                    title: Text("Baixa de SA"),
                    icon: Icon(Icons.arrow_downward)));


            }


            if (!menuSobre) {

                menuSobre = true;
                telas.add(Sobre());
                menus.add(BottomNavigationBarItem(
                    //backgroundColor: Colors.orange,
                    title: Text(""),
                    icon: Icon(Icons.assignment_late)));
                //Dados.usuarioLider = true;
            }


        }

    }



    @override
    Widget build(BuildContext context) {
        List<String> itensMenu = ["Configurações", "Sair"];

        return Scaffold(
            appBar: appBar = AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blueAccent,
                title: Text("BusLog", style: TextStyle(color: Colors.white)),
                actions: <Widget>[
                    PopupMenuButton<String>(
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
                    )
                ],
            ),
            body: Container(
                padding: EdgeInsets.all(0),
                child: telas
                [_indiceAtual],
            ),
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.blueAccent,
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
                fixedColor: Colors.white,
                items: menus
            ),
        );
    }
}
