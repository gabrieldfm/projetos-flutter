import 'package:flutter/material.dart';
import 'package:meu_carro/app/custom/rotas_widget.dart';
import 'package:meu_carro/app/pages/login/login_page.dart';

void main() {
  runApp(MaterialApp(
    title: "Meu carro",
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    initialRoute: "/",
    onGenerateRoute: RotasWidget.gerarRotas,
  ));
}

