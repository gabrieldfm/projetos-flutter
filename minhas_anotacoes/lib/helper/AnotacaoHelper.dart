import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper{

  static final String nomeTabela = "anotacao";
  static final String colunaId = "id";
  static final String colunaTitulo = "titulo";
  static final String colunaDescricao = "descricao";
  static final String colunaData = "data";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database _db;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){

  }

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDb();
      return _db;
    }
  }

  _onCreate(Database db, int versao) async {
    String sql = "CREATE TABLE anotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
    await db.execute(sql);
  }

  inicializarDb() async {
    final caminhoBanco = await getDatabasesPath();
    final localBanco = join(caminhoBanco, "banco_anotacao.db");

    return await openDatabase(
      localBanco,
      version: 1,
      onCreate: _onCreate
    );
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var banco = await db;
    return await banco.insert(nomeTabela, anotacao.toMap());
  }

  recuperarAnotacoes() async {
    var banco = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    List anotacoes = await banco.rawQuery(sql);
    return anotacoes;
  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async{
    var banco = await db;
    return await banco.update(
      nomeTabela,
      anotacao.toMap(),
      where: "id = ?",
      whereArgs: [anotacao.id]
    );
  }

  Future<int> removerAnotacao(int id)async{
    var banco = await db;
    return await banco.delete(
      nomeTabela,
      where: "id = ?",
      whereArgs: [id]
    );
  }

}