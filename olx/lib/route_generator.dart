import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/views/anuncios.dart';
import 'package:olx/views/login.dart';
import 'package:olx/views/meus_anuncios.dart';
import 'package:olx/views/novo_anuncio.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Anuncios()
        );
      case "/login":
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case "/meus-anuncios":
        return MaterialPageRoute(
          builder: (_) => MeusAnuncios()
        );
      case "/novo-anuncio":
        return MaterialPageRoute(
          builder: (_) => NovoAnuncio()
        );
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada"),
        ),
        body: Center(
          child: Text("Tela não encontrada"),
        ),
      ),
    );
  }
}