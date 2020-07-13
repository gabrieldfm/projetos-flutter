import 'package:flutter/material.dart';
import 'package:meu_carro/app/pages/cadastro/cadastro_page.dart';
import 'package:meu_carro/app/pages/login/login_page.dart';

class RotasWidget {
  static Route<dynamic> gerarRotas(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case "/":
        return MaterialPageRoute(
          builder: (_) => LoginPage()
        );
      case "/cadastro":
        return MaterialPageRoute(
            builder: (_) => CadastroPage()
          );
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(title: Text("Tela não encontrada!")),
        body: Center(
          child: Text("Tela não encontrada!")
        )
      );
    });
  }
}