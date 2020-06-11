import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerCep = TextEditingController();
  String _resultado = "Resultado";

  _recuperarCep() async {
    String url = "https://viacep.com.br/ws/${_controllerCep.text}/json/";
    http.Response response;

    response = await http.get(url);
    Map<String, dynamic> retorno =  json.decode(response.body);

    print(retorno["logradouro"]);

    setState(() {
          _resultado = retorno["logradouro"];
        });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COnsumo de serviço web"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Digite o cep: 0000000"
              ),
              style: TextStyle(
                fontSize: 20
              ),
              controller: _controllerCep,
            ),
            RaisedButton(
              child: Text("CLique aqui"),
              onPressed: _recuperarCep(),
            ),
            Text(_resultado),
          ],
        ),
      ),
    );
  }
}