import 'package:flutter/material.dart';

class AnimacaoImplicita extends StatefulWidget {
  @override
  _AnimacaoImplicitaState createState() => _AnimacaoImplicitaState();
}

class _AnimacaoImplicitaState extends State<AnimacaoImplicita> {

  bool _status = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          padding: EdgeInsets.all(20),
          width: _status ? 200 : 300,
          height: _status ? 300 : 200,
          color: _status ? Colors.white : Colors.purpleAccent,
          duration: Duration(seconds: 2),
          child: Image.asset("imagens/logo.png"),
          curve: Curves.bounceIn,
        ),
        RaisedButton(
          child: Text("Alterar"),
          onPressed: () {
            setState(() {
              _status = !_status;
            });
          },
        )
      ],
    );
  }
}