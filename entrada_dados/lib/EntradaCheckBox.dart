import 'package:flutter/material.dart';

class EntradaCheckBox extends StatefulWidget {
  @override
  _EntradaCheckBoxState createState() => _EntradaCheckBoxState();
}

class _EntradaCheckBoxState extends State<EntradaCheckBox> {

  bool _comidaBrasileira = false;
  bool _comidaMexicana = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            CheckboxListTile(
              title: Text("Comida brasileira"),
              subtitle: Text("teste"),
              //activeColor: Colors.red,
              //selected: true,
              //secondary: Icon(Icons.add_box),
              value: _comidaBrasileira,
              onChanged: (bool valor){
                setState(() {
                  _comidaBrasileira = valor;
                });
              },
            ),
            CheckboxListTile(
              title: Text("Comida mexicana"),
              subtitle: Text("teste"),
              //activeColor: Colors.red,
              //selected: true,
              //secondary: Icon(Icons.add_box),
              value: _comidaMexicana,
              onChanged: (bool valor){
                setState(() {
                  _comidaMexicana = valor;
                });
              },
            ),
            RaisedButton(
              child: Text(
                "Salvar",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: (){
                print("Comida Brasileira: " + _comidaBrasileira.toString() + " Comida mexicana: " + _comidaMexicana.toString());
              },
            )

            /*
            Text("Comida brasileira"),
            Checkbox(
              value: _selecionado,
              onChanged: (bool valor){
                setState(() {
                  _selecionado = valor;
                });
              },
            )*/
          ],
        ),
      ),
    );
  }
}