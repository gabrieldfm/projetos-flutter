import 'package:consumo_servico_avancado/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com/";
  Post post = Post(0, 1, "", "");

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(_urlBase + "/posts");
    var dadosJson = json.decode(response.body);
    List<Post> postagens = List();

    for (var post in dadosJson) {
      Post p = Post(post["userId"], post["id"], post["tittle"], post["body"]);
      postagens.add(p);
    }

    return postagens;
  }

  _post() async {
    Post post = Post(120, null, "tit", "corpo");

    var corpo = json.encode(post.toJson());

    http.Response response = await http.post(_urlBase + "/posts", 
      headers: { "Content-type": "application/json; charset=UTF-8" },
      body: corpo
    );

    var resposta = response.statusCode;
  }
  
  _put() async {
    var corpo = json.encode({
              "userId": 120,
              "id": null,
              "title": "tit alteração",
              "body": "corpo alteração"
            });

    http.Response response = await http.put(_urlBase + "/posts/2", 
      headers: { "Content-type": "application/json; charset=UTF-8" },
      body: corpo
    );

    var resposta = response.statusCode;
  }

  _patch() async {
    var corpo = json.encode({
              "userId": 120,
              "body": "corpo alteração"
            });

    http.Response response = await http.patch(_urlBase + "/posts/2", 
      headers: { "Content-type": "application/json; charset=UTF-8" },
      body: corpo
    );

    var resposta = response.statusCode;
  }

  _delete() async {
    http.Response response = await http.delete(_urlBase + "/posts/2");

    if(response.statusCode == 200){
      //ok
    }

    var resposta = response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo serviço"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Atualizar"),
                  onPressed: _patch,
                ),
                RaisedButton(
                  child: Text("Remover"),
                  onPressed: _delete,
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperarPostagens(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List<Post> lista = snapshot.data;
                            Post post = lista[index];

                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.body),
                            );
                          },
                        );
                      }
                      break;
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
