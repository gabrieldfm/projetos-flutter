import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/model/Usuario.dart';

class UsuarioFirebase {
  static Future<FirebaseUser> getUsuarioAtual()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.currentUser();
  }

  static Future<Usuario> getDadosUsuarioLogado()async{
    FirebaseUser firebaseUser = await getUsuarioAtual();
    String idUsuario = firebaseUser.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
      .document(idUsuario)
      .get();

    Map<String, dynamic> dados = snapshot.data;
    String tipoUsuario = dados["tipoUsuario"];
    String nome = dados["nome"];
    String email = dados["email"];

    Usuario usuario = Usuario();
    usuario.nome = nome;
    usuario.email = email;
    usuario.tipoUsuario = tipoUsuario;

    return usuario;
  }

  static atualizarDadosLocalizacao(String idRequisicao, double lat, double lon) async{
    Firestore db = Firestore.instance;

    Usuario motorista = await getDadosUsuarioLogado();
    motorista.latitude = lat;
    motorista.longitude = lon;

    db.collection("requisicoes")
      .document(idRequisicao)
      .updateData({
        "motorista" : motorista.toMap()
      });
  }
}