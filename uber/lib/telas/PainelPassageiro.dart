import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PainelPassageiro extends StatefulWidget {
  @override
  _PainelPassageiroState createState() => _PainelPassageiroState();
}

class _PainelPassageiroState extends State<PainelPassageiro> {
  List<String> itensMenu = ["Deslogar", "Configurações"];

  _escolhaItemMenu(String escolha){
    switch (escolha) {
      case "Deslogar":
        _deslogar();
        break;
      case "Configurações":
        break;
    }
  }

  _deslogar()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("painel passageiro"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaItemMenu,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(),
    );
  }
}