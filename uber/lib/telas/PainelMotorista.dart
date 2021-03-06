import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber/util/StatusRequisicao.dart';
import 'package:uber/util/UsuarioFirebase.dart';

class PainelMotorista extends StatefulWidget {
  @override
  _PainelMotoristaState createState() => _PainelMotoristaState();
}

class _PainelMotoristaState extends State<PainelMotorista> {

  List<String> itensMenu = ["Deslogar", "Configurações"];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;

  _escolhaItemMenu(String escolha){
    switch (escolha) {
      case "Deslogar":
        _deslogar();
        break;
      case "Configurações":
        break;
    }
  }

  _deslogar()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  Stream<QuerySnapshot> _adicionarListenerRequisicoes(){
    final stream = db.collection("requisicoes")
      .where("status", isEqualTo: StatusRequisicao.AGUARDANDO)
      .snapshots();

    stream.listen((dados){
      _controller.add(dados);
    });
  }

  _recuperarRequisicaoAtivaMotorista()async{
    FirebaseUser firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    DocumentSnapshot documentSnapshot = await db.collection("requisicao_ativa_motorista")
      .document(firebaseUser.uid)
      .get();
    
    var dadosRequisicao = documentSnapshot.data;
    if (dadosRequisicao == null) {
      _adicionarListenerRequisicoes();
    }else{
      Navigator.pushReplacementNamed(context, 
          "/corrida", arguments: dadosRequisicao["id_requisicao"]);
    }
  }

  @override
  void initState() {
    super.initState();

    _recuperarRequisicaoAtivaMotorista();
  }

  @override
  Widget build(BuildContext context) {

    var mensagemCarregando = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando requisições"),
          CircularProgressIndicator()
        ],
      ),
    );

    var mensagemSemDados = Center(
      child: Text(
        "Você não tem nenhuma requisição",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("painel motorista"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaItemMenu,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return mensagemCarregando;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro ao carregar os dados");
              } else {
                QuerySnapshot querySnapshot = snapshot.data;
                if (querySnapshot.documents.length == 0) {
                  return mensagemSemDados;
                }else{
                  return ListView.separated(
                    itemBuilder: (context, indice){
                      List<DocumentSnapshot> requisicoes = querySnapshot.documents.toList();
                      DocumentSnapshot item = requisicoes[indice];

                      String idRequisicao = item["id"];
                      String nomePassageiro = item["passageiro"]["nome"];
                      String rua = item["destino"]["rua"];
                      String numero = item["destino"]["numero"];

                      return ListTile(
                        title: Text(nomePassageiro),
                        subtitle: Text("destino: $rua, $numero"),
                        onTap: (){
                          Navigator.pushNamed(context, 
                            "/corrida", arguments: idRequisicao
                          );
                        },
                      );
                    }, 
                    separatorBuilder: (context, indice) => Divider(
                      height: 2,
                      color: Colors.grey,
                    ), 
                    itemCount: querySnapshot.documents.length
                  );

                }
              }
              break;
          }
        },
      ),
    );
  }
}