class Usuario {
  String _idUsuario;
  String _nome;
  String _email;
  String senha;

  Usuario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idUsuario" : this.idUsuario,
      "nome" : this.nome,
      "email" : this.email
    };

    return map;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) => _idUsuario = value;

  String get nome => _nome;

  set nome(String value) => _nome = value;

  String get email => _email;

  set email(String value) => _email = value;

  String get getSenha => senha;

  set setSenha(String senha) => this.senha = senha;
}
