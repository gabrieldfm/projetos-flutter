import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/views/anuncios.dart';
import 'package:olx/views/login.dart';

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