import 'package:flutter/material.dart';
import 'package:uber/telas/Home.dart';

class Rotas{

  static Route<dynamic> gerarRotas(RouteSettings settings){
    switch(settings.name){
      case "/":
        return MaterialPageRoute(
          builder: (_) => Home()
        );
    }
  }
}