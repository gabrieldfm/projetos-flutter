import 'package:brasil_fields/modelos/estados.dart';
import 'package:flutter/material.dart';

class Configuracoes {
  static List<DropdownMenuItem<String>> getCategorias(){
    List<DropdownMenuItem<String>> listaCategoria = [];

    listaCategoria.add(
      DropdownMenuItem(
        child: Text("Categoria", style: TextStyle(color: Color(0xff9c27b0)),),
        value: null,
      )
    );

    listaCategoria.add(
      DropdownMenuItem(
        child: Text("Automóvel"),
        value: "auto",
      )
    );

    listaCategoria.add(
      DropdownMenuItem(
        child: Text("Imóvel"),
        value: "imovel",
      )
    );

    listaCategoria.add(
      DropdownMenuItem(
        child: Text("Eletronicos"),
        value: "eletro",
      )
    );

    listaCategoria.add(
      DropdownMenuItem(
        child: Text("Espotes"),
        value: "esporte",
      )
    );

    return listaCategoria;
  }

  static List<DropdownMenuItem<String>> getEstados(){
    List<DropdownMenuItem<String>> listaEstados = [];

    listaEstados.add(
      DropdownMenuItem(
        child: Text("Região", style: TextStyle(color: Color(0xff9c27b0)),),
        value: null,
      )
    );

    for (var estado in Estados.listaEstadosAbrv) {
      listaEstados.add(
        DropdownMenuItem(
          child: Text(estado),
          value: estado,
        )
      );
    }   

    return listaEstados;

  }
}