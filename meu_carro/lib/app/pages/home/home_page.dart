import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meu_carro/app/pages/abas/aba_oficina_page.dart';
import 'package:meu_carro/app/pages/abas/aba_veiculo_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  List<String> listaOpcoes = ["Configurações", "Deslogar"];

  _escolhamneuItem(String itemEscolhido){

    switch(itemEscolhido){
      case "Configurações":
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async{
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carro"),
        elevation: Platform.isIOS ? 0 : 4,
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Platform.isIOS ? Colors.grey[400] : Colors.white,
          tabs: <Widget>[
            Tab(text: "Meus Veículos",),
            Tab(text: "Oficinas",),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (context){
              return listaOpcoes.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              } ).toList();
            },
            onSelected: _escolhamneuItem,
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          AbaVeiculoPage(),
          AbaOficinaPage()
        ],
      ),
    );
  }
}