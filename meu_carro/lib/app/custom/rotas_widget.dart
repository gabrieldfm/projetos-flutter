import 'package:flutter/material.dart';
import 'package:meu_carro/app/pages/cadastro/cadastro_page.dart';
import 'package:meu_carro/app/pages/home/home_page.dart';
import 'package:meu_carro/app/pages/login/login_page.dart';
import 'package:meu_carro/app/pages/mapas/mapa_oficina_page.dart';

class RotasWidget {
  static Route<dynamic> gerarRotas(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case "/":
        return MaterialPageRoute(
          builder: (_) => LoginPage()
        );
      case "/login":
        return MaterialPageRoute(
          builder: (_) => LoginPage()
        );
      case "/home":
        return MaterialPageRoute(
          builder: (_) => HomePage()
        );
      case "/cadastro":
        return MaterialPageRoute(
            builder: (_) => CadastroPage()
          );
      case "/mapa_oficina":
        return MaterialPageRoute(
          builder: (_) => MapaOficinaPage(args)
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