import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

void main() async{

  /*Firestore db = Firestore.instance;

  /*db.collection("usuarios")
  .document("001")
  .setData({
    "nome":"eu",
    "idade":"5"
  });*/

  //id automatico
  // DocumentReference ref = await db.collection("noticias")
  // .add(
  //   {
  //     "titulo":"manchete",
  //     "descricao":"bla bla"
  //   }
  // );

  // db.collection("noticias")
  // .document(ref.documentID)
  // .setData(
  //   {
  //     "titulo":"manchetealterado",
  //     "descricao":"bla bla"
  //   }
  // );

  // db.collection("usuarios")
  // .document("003")
  // .delete();

  // DocumentSnapshot snapshot = await db.collection("usuarios")
  // .document("001")
  // .get();

  QuerySnapshot query = await db.collection("usuarios")
  .getDocuments();

  for (DocumentSnapshot item in query.documents) {
    var dados = item.data;
  }

  //notifica qndo altera
  db.collection("usuarios")
  .snapshots().listen(
    (snapshot){
      print(snapshot.documents.toString());

      for (DocumentSnapshot item in snapshot.documents) {
        var dados = item.data;
      }
    }
  );

  //filtros
  QuerySnapshot querySnapshot = await db.collection("usuarios")
  //.where("nome", isEqualTo: "marcelo")
  //.where("idade", isEqualTo: 31)
  //.where("idade", isGreaterThan: 15)
  //.where("idade", isLessThan: 30)
  //.orderBy("idade", descending: true)
  //.orderBy("nome", descending: false)
  //.limit(2)
  .where("nome", isGreaterThanOrEqualTo: "m")
  .where("nome", isLessThanOrEqualTo: "m" + "\uf8ff")
  .getDocuments();

  for (var item in querySnapshot.documents) {
    var dados = item.data;

  }

  //play services
  FirebaseAuth auth = FirebaseAuth.instance;

  String email = "gabrieldfm@gmail.com";
  String senha = "123";

  //criação
  auth.createUserWithEmailAndPassword(
    email: email, password: senha)
    .then((firebaseUser){
      print("sucesso: "+ firebaseUser.email);
    }).catchError((error){
      print("erro: "+ error.toString());
    });

  auth.signOut();
  //logado
  auth.signInWithEmailAndPassword(email: email, password: senha)
  .then((firbaseUser){
    print("sucesso: "+ firbaseUser.email);
  }).catchError((error){
    print("erro: "+ error.toString());
  });

  FirebaseUser usuarioAtual = await auth.currentUser();
  if(usuarioAtual != null){

  }else{
    //deslogado
  }
*/


  
  runApp(
    MaterialApp(
      home: Home(),
    )
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _imagem;
  String _statusUpload = "Upload não iniciado";
  String _urlImagemRecup = null;

  Future _recuperarImagem(bool camera) async{
    File imagemSelecionada;
    if (camera) {
      imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
    }else{
      imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _imagem = imagemSelecionada;
    });
  }

  Future _uploadImagem() async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("fotos").child("foto1.jpg");

    StorageUploadTask task =  arquivo.putFile(_imagem);

    task.events.listen((StorageTaskEvent storageEvent){
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _statusUpload = "Em progresso";
        });
      }else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _statusUpload = "Upload finalizado";
        });
      }
    });

    //recuperar imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrl(snapshot); 
    });
  }

  Future _recuperarUrl(StorageTaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _urlImagemRecup = url;
    });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("selecionar imagem"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(_statusUpload),
            RaisedButton(
              child: Text("camera"),
              onPressed: (){
                _recuperarImagem(true);
              },
            ),
            RaisedButton(
              child: Text("galeria"),
              onPressed: (){
                _recuperarImagem(false);
              },
            ),
            _imagem == null
            ? Container() :
            Image.file(_imagem),
            _imagem == null
            ? Container() :
            RaisedButton(
              child: Text("upload storage"),
              onPressed: (){
                _uploadImagem();
              },
            ),
            _urlImagemRecup == null 
            ? Container() :
            Image.network(_urlImagemRecup)
          ],
        ),
      ),
    );
  }
}
