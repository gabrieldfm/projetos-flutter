import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {

    final caminhoBanco = await getDatabasesPath();
    final localBanco = join(caminhoBanco, "banco.db");

    return await openDatabase(
      localBanco,
      version: 1,
      onCreate: (db, dbVersaoAtual){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      }
    );
  }

  _salvarDados() async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome" : "Teste",
      "idade" : 26
    };

    int id = await bd.insert("usuarios", dadosUsuario);
    print("id salvo $id");
  }

  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios";

    List usuarios = await  bd.rawQuery(sql);

    for (var usuario in usuarios) {
      print("id: ${usuario['id'].toString()}");
    }

    //print("usuarios ${usuarios.toString()}");
  }
  
  _recuperarPeloId(int id) async {
    Database bd = await _recuperarBancoDados();

    List usuarios = await  bd.query(
      "usuarios",
      columns: ["id", "nome", "idade"],
      where: "id = ?",
      whereArgs: [id]
    );

    for (var usuario in usuarios) {
      print("id: ${usuario['id'].toString()}");
    }
  }

  _excluirUsuario(int id) async{
    Database bd = await _recuperarBancoDados();

    int retorno = await bd.delete("usuarios", where: "id = ?", whereArgs: [id]);
  }

  _atualizarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome" : "alterado",
      "idade" : 24
    };

    bd.update("usuarios", dadosUsuario, where: "id = ?", whereArgs: [id]);
  }

  @override
  Widget build(BuildContext context) {
    //_salvarDados();
    //_listarUsuarios();
    _recuperarPeloId(1);
    return Container(
      
    );
  }
}