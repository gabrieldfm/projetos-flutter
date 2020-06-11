import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/model/Usuario.dart';

class AbaConversas extends StatefulWidget {
  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {

  List<Conversa> _conversas = List();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  String _idUsuarioLogado;

  @override
  void initState() {
    super.initState();
    _recuperarUsuario();
    Conversa conversa = Conversa();

    conversa.nome = "Carlos";
    conversa.mensagem =  "Oi, td bem";
    conversa.caminhoFoto = "https://firebasestorage.googleapis.com/v0/b/whatsapp-30143.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=9df6d5e9-36bf-4946-bce7-030855a2d847";
    _conversas.add(conversa);
  }

  Stream<QuerySnapshot> _adicionarListernerConversa(){
    final stream = db.collection("conversas")
      .document(_idUsuarioLogado)
      .collection("ultima_conversa")
      .snapshots();

    stream.listen((dados){
      _controller.add(dados);
    });
  }

  _recuperarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    _adicionarListernerConversa();

  }

  @override
  void dispose(){
    super.dispose();
    _controller.close();
  }
  
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot){
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando conversas"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError){
              return Text("Erro ao carregar dados");
            }else{
              QuerySnapshot querySnapshot = snapshot.data;
              if (querySnapshot.documents.length == 0) {
                return Center(
                  child: Text(
                    "Você não tem nenhuma mensagem ainda",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: _conversas.length,
                itemBuilder: (context, index){
                  List<DocumentSnapshot> conversas = querySnapshot.documents.toList();
                  DocumentSnapshot item = conversas[index];

                  String urlImagem = item["caminhoFoto"];
                  String tipo = item["tipo"];
                  String mensagem = item["mensagem"];
                  String nome = item["nome"];
                  String idDestinatario = item["idDestinatario"];

                  Usuario usuario = Usuario();
                  usuario.nome = nome;
                  usuario.urlImagem = urlImagem;
                  usuario.idUsuario = idDestinatario;               

                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, "/mensagens", 
                        arguments: usuario
                      );
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: urlImagem != null ? NetworkImage(urlImagem) : null,
                    ),
                    title: Text(
                      nome,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    subtitle: Text(
                      tipo == "texto" ? mensagem : "Imagem...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                      ),
                    ),
                  );
                },
              );
            }
        }
      },
    );

    
  }
}