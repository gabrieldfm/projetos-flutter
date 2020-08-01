import 'package:flutter/material.dart';
import 'package:ishow_app/inputCustomizado.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("imagens/fundo.png"),
                    fit: BoxFit.fill
                  )
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 10,
                      child: Image.asset("imagens/detalhe1.png"),
                    ),
                    Positioned(
                      left: 50,
                      child: Image.asset("imagens/detalhe2.png"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          InputCustomizado(
                            hint: "Email",
                            obscure: false,
                            icon: Icon(Icons.person),
                          ),
                          InputCustomizado(
                            hint: "Senha",
                            obscure: true,
                            icon: Icon(Icons.lock),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200],
                            blurRadius: 15,
                            spreadRadius: 4
                          )
                        ]
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        
                      },
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 100, 127, 1),
                              Color.fromRGBO(255, 123, 145, 1),
                            ]
                          )
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Esqueci minha senha!",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 100, 127, 1),
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}