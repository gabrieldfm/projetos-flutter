import 'package:flutter/material.dart';

class EntradaSlider extends StatefulWidget {
  @override
  _EntradaSliderState createState() => _EntradaSliderState();
}

class _EntradaSliderState extends State<EntradaSlider> {

  double _valor = 0;
  String _label = "0";

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados"),
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          children: <Widget>[

            Slider(
              value: _valor,
              min: 0,
              max: 10,
              label: _label,
              divisions: 10,
              activeColor: Colors.red,
              onChanged: (double valor){
                setState(() {
                  _valor = valor;
                  _label = valor.toString();
                });
              },

            ),
            
            RaisedButton(
              child: Text(
                "Salvar",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: (){
                print("valor: " + _valor.toString());
              },
            )

          ],
        ),
      ),
    );
  }
}