import 'package:flutter/material.dart';

class AnimacaoImplicita extends StatefulWidget {
  @override
  _AnimacaoImplicitaState createState() => _AnimacaoImplicitaState();
}

class _AnimacaoImplicitaState extends State<AnimacaoImplicita> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          width: 200,
          height: 200,
          color: Colors.purpleAccent,
          child: Image.asset("imagens/logo.png"),
        ),
        RaisedButton(
          child: Text("Alterar"),
          onPressed: () {
            setState(() {
              
            });
          },
        )
      ],
    );
  }
}