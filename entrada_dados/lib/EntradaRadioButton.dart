import 'package:flutter/material.dart';


class EntradaRadioButton extends StatefulWidget {
  @override
  _EntradaRadioButtonState createState() => _EntradaRadioButtonState();
}

class _EntradaRadioButtonState extends State<EntradaRadioButton> {

  String _escolha;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados"),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            /*Text("Masculino"),
            Radio(
              value: "M",
              groupValue: _escolha,
              onChanged: (String escolha){
                setState(() {
                  _escolha = escolha;
                });
                print("resultado: " + escolha);

              },
            ),
            Text("Feminino"),
            Radio(
              value: "F",
              groupValue: _escolha,
              onChanged: (String escolha){
                setState(() {
                  _escolha = escolha;
                });
                print("resultado: " + escolha);
              },
            ),*/
            RadioListTile(
              title: Text("Masculino"),
              value: "M",
              groupValue: _escolha,
              onChanged: (String escolha){
                setState(() {
                  _escolha = escolha;
                });
              },
            ),
            RadioListTile(
              title: Text("Feminino"),
              value: "F",
              groupValue: _escolha,
              onChanged: (String escolha){
                setState(() {
                  _escolha = escolha;
                });
              },
            ),
            RaisedButton(
              child: Text(
                "Salvar",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: (){
                print("Resultado: " + _escolha);
              },
            )


          ],
        ),
      ),
    );
  }
}