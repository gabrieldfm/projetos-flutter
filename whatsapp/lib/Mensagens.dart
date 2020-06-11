import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/model/Mensagem.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Mensagens extends StatefulWidget {
  Usuario contato;

  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  File _imagem;
  Firestore db = Firestore.instance;
  TextEditingController _controllerMsg = TextEditingController();
  String _idUsuarioLogado;
  String _idUsuarioDestinatario;
  bool _upArquivo = false;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController _scrollController = ScrollController();

  Stream<QuerySnapshot> _adicionarListernerMsg(){
    final stream = db
          .collection("mensagens")
          .document(_idUsuarioLogado)
          .collection(_idUsuarioDestinatario)
          .orderBy("data", descending: false)
          .snapshots();

    stream.listen((dados){
      _controller.add(dados);
      Timer(Duration(seconds: 1), (){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  _enviarMsg() {
    String textoMsg = _controllerMsg.text;
    if (textoMsg.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMsg;
      mensagem.urlImagem = "";
      mensagem.data = Timestamp.now().toString();
      mensagem.tipo = "texto";

      _salvarMsg(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
      _salvarMsg(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);

      _salvarConversa(mensagem);

    }
  }

  _salvarConversa(Mensagem msg){

    Conversa cRemetente = Conversa();

    cRemetente.idRemetente = _idUsuarioLogado;
    cRemetente.idDestinatario = _idUsuarioDestinatario;
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.contato.nome;
    cRemetente.caminhoFoto = widget.contato.urlImagem;
    cRemetente.tipoMensagem = msg.tipo;
    cRemetente.slavar();

    Conversa cDestinatario = Conversa();

    cDestinatario.idRemetente = _idUsuarioDestinatario;
    cDestinatario.idDestinatario = _idUsuarioLogado;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.contato.nome;
    cDestinatario.caminhoFoto = widget.contato.urlImagem;
    cDestinatario.tipoMensagem = msg.tipo;
    cDestinatario.slavar();
    
  }

  _salvarMsg(String idRemetente, String idDestinatario, Mensagem msg) async {
    await db
        .collection("mensagens")
        .document(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    _controllerMsg.clear();
  }

  _enviarFoto() async{
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
    _upArquivo = true;

    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage db = FirebaseStorage.instance;
    StorageReference pastaRaiz = db.ref();
    StorageReference arquivo = pastaRaiz
      .child("mensagens")
      .child(_idUsuarioLogado)
      .child(nomeImagem + ".jpg");

    StorageUploadTask task = arquivo.putFile(imagemSelecionada);   

    task.events.listen((StorageTaskEvent storageEvent) {

      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _upArquivo = true;
        });
        
      }else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _upArquivo = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();

    Mensagem mensagem = Mensagem();
    mensagem.idUsuario = _idUsuarioLogado;
    mensagem.mensagem = "";
    mensagem.urlImagem = url;
    mensagem.data = Timestamp.now().toString();
    mensagem.tipo = "imagem";

    _salvarMsg(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
    _salvarMsg(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);
    
  }

  _recuperarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    _idUsuarioDestinatario = widget.contato.idUsuario;
    _adicionarListernerMsg();
  }

  @override
  void initState() {
    super.initState();
    _recuperarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMsg = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMsg,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite msensagem",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    prefixIcon: IconButton(
                        icon: 
                        _upArquivo ? CircularProgressIndicator():
                        Icon(Icons.camera_alt), onPressed: _enviarFoto)),
              ),
            ),
          ),
          Platform.isIOS ? 
          CupertinoButton(
            child: Text("Enviar"),
            onPressed: _enviarMsg,
          ) : 
          FloatingActionButton(
            onPressed: _enviarMsg,
            backgroundColor: Color(0xff075E54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
          )
        ],
      ),
    );

    var stream = StreamBuilder(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando mensagens"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            if (snapshot.hasError) {
              return Text("Erro ao carregar dados");
            } else {
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {

                    List<DocumentSnapshot> mensagens = querySnapshot.documents.toList();
                    DocumentSnapshot item = mensagens[index];
                    double largura = MediaQuery.of(context).size.width * 0.8;

                    Alignment alinhamento = Alignment.centerRight;
                    Color cor = Color(0xffd2ffa5);
                    if (_idUsuarioLogado != item["idUsuario"]) {
                      alinhamento = Alignment.centerLeft;
                      cor = Colors.white;
                    }

                    return Align(
                      alignment: alinhamento,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Container(
                          width: largura,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: cor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: 
                            item["tipo"] == "texto" ? Text(item["mensagem"], style: TextStyle(fontSize: 18),)
                            : Image.network(item["urlImagem"])
                        ),
                      ),
                    );
                  },
                  itemCount: querySnapshot.documents.length,
                ),
              );
            }

            break;
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: widget.contato.urlImagem != null
                  ? NetworkImage(widget.contato.urlImagem)
                  : null,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(widget.contato.nome),
            )
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imagens/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[stream, caixaMsg],
          ),
        )),
      ),
    );
  }
}
