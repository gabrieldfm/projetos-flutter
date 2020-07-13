import 'package:flutter/material.dart';
import 'package:meu_carro/app/models/oficina_model.dart';

class AbaOficinaPage extends StatefulWidget {
  @override
  _AbaOficinaPageState createState() => _AbaOficinaPageState();
}

class _AbaOficinaPageState extends State<AbaOficinaPage> {
  List<Oficina> _oficinas = List<Oficina>();

  _listarOficinas() {
    List<Oficina> oficinas = List<Oficina>();
    Oficina oficina1 = Oficina();
    oficina1.nome = "Oficina mecanica di franco";
    oficina1.rua = "Pedro tomasi";
    oficina1.numero = "102";
    oficina1.latitude = -29.173472;
    oficina1.longitude = -51.189213;
    oficinas.add(oficina1);

    Oficina oficina2 = Oficina();
    oficina2.nome = "Mecanica do maneca Ltda";
    oficina1.rua = "Mal. floriano";
    oficina1.numero = "10";
    oficina2.latitude = -29.161556;
    oficina2.longitude = -51.194191;
    oficinas.add(oficina2);

    setState(() {
      _oficinas = oficinas;
    });
  }

  @override
  void initState() {
    super.initState();
    _listarOficinas();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      itemBuilder: (context, index) {
        final item = _oficinas[index];

        return Card(
          child: ListTile(
            title: Text(item.nome),
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            subtitle: Text("${(item.rua)} - ${item.numero}"),
            onTap: (){
              Navigator.pushNamed(context, "/mapa_oficina", 
                arguments: item
              );
            },
          ),
        );
      },
      itemCount: _oficinas.length,
    ));
  }
}
