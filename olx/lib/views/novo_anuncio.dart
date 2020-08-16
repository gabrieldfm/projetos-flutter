import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'package:olx/views/widgets/input_customizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  List<File> _listaImagens = List();
  List<DropdownMenuItem<String>> _listaEstados = List();
  List<DropdownMenuItem<String>> _listaCategoria = List();
  final _formKey = GlobalKey<FormState>();
  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;
  Anuncio _anuncio;

  _selecionarImagem()async{
    //metodo obsoleto
    File imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imagemSelecionada != null) {
      _listaImagens.add(imagemSelecionada);
    }
  }

  _carregarItensDropDown(){

    _listaCategoria.add(
      DropdownMenuItem(
        child: Text("Automóvel"),
        value: "auto",
      )
    );

    _listaCategoria.add(
      DropdownMenuItem(
        child: Text("Imóvel"),
        value: "imovel",
      )
    );

    _listaCategoria.add(
      DropdownMenuItem(
        child: Text("Eletronicos"),
        value: "eletro",
      )
    );

    _listaCategoria.add(
      DropdownMenuItem(
        child: Text("Espotes"),
        value: "esporte",
      )
    );

    for (var estado in Estados.listaEstadosAbrv) {
      _listaEstados.add(
        DropdownMenuItem(
          child: Text(estado),
          value: estado,
        )
      );
    }
  }

  _salvarAnuncio()async{
    await _uploadImagens();
  }

  Future _uploadImagens()async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();

    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference arquivo = pastaRaiz
        .child("meus_anuncios")
        .child(_anuncio.id)
        .child(nomeImagem);

      StorageUploadTask uploadTask = arquivo.putFile(imagem);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();
    _anuncio = Anuncio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens){
                    if (imagens.length == 0) {
                      return "Necessário selecionar uma imagem";
                    }

                    return null;
                  },
                  builder: (state){
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listaImagens.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _listaImagens.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                      _selecionarImagem();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                              color: Colors.grey[100]
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (_listaImagens.length > 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Image.file(_listaImagens[index]),
                                              FlatButton(
                                                child: Text("Excluir"),
                                                onPressed: (){
                                                  setState(() {
                                                    _listaImagens.removeAt(index);
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(_listaImagens[index]),
                                      child: Container(
                                        color: Color.fromRGBO(255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.delete, color: Colors.red,),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Container();
                            },
                          ),
                        ),
                        if(state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEstado,
                          hint: Text("Estados"),
                          onSaved: (estado){
                            _anuncio.estado = estado;
                          },
                          validator: (value) {
                            return Validador().add(Validar.OBRIGATORIO, msg: "Campo obrigatório").valido(value);
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),
                          items: _listaEstados,
                          onChanged: (value) {
                            setState(() {
                              _itemSelecionadoEstado = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoCategoria,
                          hint: Text("Categoria"),
                          onSaved: (categoria){
                            _anuncio.categoria = categoria;
                          },
                          validator: (value) {
                            return Validador().add(Validar.OBRIGATORIO, msg: "Campo obrigatório").valido(value);
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),
                          items: _listaCategoria,
                          onChanged: (value) {
                            setState(() {
                              _itemSelecionadoCategoria = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: "Titulo",
                    onSaved: (titulo){
                      _anuncio.titulo = titulo;
                    },
                    validator: (valor){
                      return Validador().add(Validar.OBRIGATORIO, msg: "Campo obrigatório").valido(valor);
                    },
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Preço",
                    onSaved: (preco){
                      _anuncio.preco = preco;
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true)
                    ],
                    validator: (valor){
                      return Validador().add(Validar.OBRIGATORIO, msg: "Campo obrigatório").valido(valor);
                    },
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Teloefone",
                    onSaved: (telefone){
                      _anuncio.telefone = telefone;
                    },
                    type: TextInputType.phone,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    validator: (valor){
                      return Validador().add(Validar.OBRIGATORIO, msg: "Campo obrigatório").valido(valor);
                    },
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Descrição",
                    onSaved: (descricao){
                      _anuncio.descricao = descricao;
                    },
                    maxLines: null,
                    validator: (valor){
                      return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        .maxLength(200, msg: "Maximo de 200 caracteres")
                        .valido(valor);
                    },
                  )
                ),
                BotaoCustomizado(
                  texto: "Cadastrar anúncio",
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      _formKey.currentState.save();

                      _salvarAnuncio();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}