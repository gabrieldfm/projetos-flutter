import 'package:uber/model/Destino.dart';
import 'package:uber/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Requisicao {
  String _id;
  String _status;
  Usuario _passageiro;
  Usuario _motorista;
  Destino _destino;

  Requisicao(){
    Firestore db = Firestore.instance;
    DocumentReference ref = db.collection("requisicoes").document();
    this.id = ref.documentID;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> dadsoPassageiro ={
      "nome": this.passageiro.nome,
      "email": this.passageiro.email,
      "tipoUsuario": this.passageiro.tipoUsuario,
      "idUsuario": this.passageiro.idUsuario,
      "latitude": this.passageiro.latitude,
      "longitude": this.passageiro.longitude,
    };

    Map<String, dynamic> dadsoDestino ={
      "rua": this.destino.rua,
      "numero": this.destino.numero,
      "bairro": this.destino.bairro,
      "cep": this.destino.cep,
      "latitude": this.destino.latitude,
      "longitude": this.destino.longitude,
    };

    Map<String, dynamic> dadsoRequisicao ={
      "id": this.id,
      "status": this.status,
      "passageiro": dadsoPassageiro,
      "motorista": null,
      "destino": dadsoDestino,
    };
    return dadsoRequisicao;
  }

  String get id => _id;

  set id(String value) => _id = value;

  String get status => _status;

  set status(String value) => _status = value;

  Usuario get passageiro => _passageiro;

  set passageiro(Usuario value) => _passageiro = value;

  Usuario get motorista => _motorista;

  set motorista(Usuario value) => _motorista = value;

  Destino get destino => _destino;

  set destino(Destino value) => _destino = value;
}
