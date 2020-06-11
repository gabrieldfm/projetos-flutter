import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  TextEditingController _controllerNome = TextEditingController();
  File _imagem;
  String _idUsuarioLogado;
  bool _upArquivo = false;
  String _urlImg;

  Future _recuperarImagem(String origem) async{

    File imagemSelecionada;

    switch(origem){
      case "Galeria":
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
      case "Camera":
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      
      _imagem = imagemSelecionada;
      if (_imagem != null) {
        _upArquivo = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem()async{
    FirebaseStorage db = FirebaseStorage.instance;
    StorageReference pastaRaiz = db.ref();
    StorageReference arquivo = pastaRaiz
      .child("perfil")
      .child(_idUsuarioLogado + ".jpg");

    StorageUploadTask task = arquivo.putFile(_imagem);   

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
    _aturalizarImagemFireStore(url);
    setState(() {
      _urlImg = url;
    });

  }

  _aturalizarNomeFireStore(){
    String nome = _controllerNome.text;
    Firestore db = Firestore.instance;
    Map<String, dynamic> dadosAtualizar = {
      "nome":  nome
    };

    db.collection("usuarios")
    .document(_idUsuarioLogado)
    .updateData(dadosAtualizar);
  }

  _aturalizarImagemFireStore(String url){
    Firestore db = Firestore.instance;
    Map<String, dynamic> dadosAtualizar = {
      "urlImagem":  url
    };

    db.collection("usuarios")
    .document(_idUsuarioLogado)
    .updateData(dadosAtualizar);
  }

  _recuperarUsuario()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
      .document(_idUsuarioLogado)
      .get();

    Map<String, dynamic> dadosRecuperados = snapshot.data;
    _controllerNome.text = dadosRecuperados["nome"];

    if (dadosRecuperados["urlImagem"] != null) {
      _urlImg = dadosRecuperados["urlImagem"];      
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: _upArquivo ? CircularProgressIndicator() : Container(),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: _urlImg != null ? NetworkImage(_urlImg) : null ,
                  backgroundColor: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        _recuperarImagem("Camera");
                      }, 
                      child: Text("Camera")
                    ),
                    FlatButton(
                      onPressed: (){
                        _recuperarImagem("Galeria");
                      }, 
                      child: Text("Galeria")
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    onChanged: (texto){
                      //_aturalizarNomeFireStore(texto);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                      )
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                      child: Text(
                        "Salvar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                      color: Colors.green,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: (){
                        _aturalizarNomeFireStore();
                      }
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}