import 'package:flutter/material.dart';


class EntradaSwitch extends StatefulWidget {
  @override
  _EntradaSwitchState createState() => _EntradaSwitchState();
}

class _EntradaSwitchState extends State<EntradaSwitch> {

  bool _escolha = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: Text("Receber notificação?"),
              value: _escolha,
              onChanged: (bool valor){
                setState(() {
                  _escolha = valor;
                });
              },
            ),
            RaisedButton(
              child: Text(
                "Salvar",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: (){
                print("Resultado: " + _escolha.toString());
              },
            )


            /*
            Switch(
              value: _escolha,
              onChanged: (bool valor){
                setState(() {
                  _escolha = valor;
                });
              },
            ),
            Text("Receber notificação?")*/

          ],
        ),
      ),
    );
  }
}