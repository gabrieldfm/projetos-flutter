import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/model/Usuario.dart';
import 'package:uber/util/StatusRequisicao.dart';
import 'package:uber/util/UsuarioFirebase.dart';

class Corrida extends StatefulWidget {
  String idRequisicao;

  Corrida(this.idRequisicao);

  @override
  _CorridaState createState() => _CorridaState();
}

class _CorridaState extends State<Corrida> {

  List<String> itensMenu = ["Deslogar", "Configurações"];
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-26.0000, -240000));
  Set<Marker> _marcadores = {};
  Map<String, dynamic> _dadosRequisicao;
  Position _localMotorista;

  //Controles
  String _textoBotao = "Aceitar corrida";
  Color _corBotao = Color(0xff1ebbd8);
  Function _funcaoBotao;

  _alterarBotaPrincipal(String texto, Color cor, Function funcao){
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _exibirMarcadorPassageiro(position);

      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 19);
      _movimentarCamera(_posicaoCamera);
      setState(() {
        _localMotorista = position;
      });
    });
  }

  _recuperarUltimaLocalizacaoConhecida() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      if (position != null) {
        _exibirMarcadorPassageiro(position);
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);

        _movimentarCamera(_posicaoCamera);
        _localMotorista = position;
      }
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _exibirMarcadorPassageiro(Position local) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/motorista.png")
        .then((BitmapDescriptor icone) {
      Marker marcadorMotorista = Marker(
          markerId: MarkerId("marcador-motorista"),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: "Meu local"),
          icon: icone);
      setState(() {
        _marcadores.add(marcadorMotorista);
      });
    });
  }

  _recuperarRequisicao()async{

    String idRequisicao = widget.idRequisicao;
    Firestore db = Firestore.instance;

    DocumentSnapshot documentSnapshot = await db.collection("requisicoes")
      .document(idRequisicao)
      .get();

    _dadosRequisicao = documentSnapshot.data;
    _adicionarListenerRequisicao();
  }

  _adicionarListenerRequisicao() async{
    Firestore db = Firestore.instance;
    String idRequisicao = _dadosRequisicao["id"];
    await db.collection("requisicoes")
      .document(idRequisicao)
      .snapshots()
      .listen((snapshot) { 
        if (snapshot.data != null) {
          Map<String, dynamic> dados = snapshot.data;
          String status = dados["status"];

          switch (status) {
            case StatusRequisicao.AGUARDANDO:
              _statusAguardando();
              break;
            case StatusRequisicao.A_CAMINHO:
              _statusaCaminho();
              break;
            case StatusRequisicao.VIAGEM:
              
              break;
            case StatusRequisicao.FINALIZADA:
              
              break;
          }
        }
      });
  }

  _statusAguardando(){
    _alterarBotaPrincipal("Aceitar corrida", Color(0xff1ebbd8), (){
      _aceitarCorrida();
    });
  }
  
  _aceitarCorrida()async{
    String idRequisicao = _dadosRequisicao["id"];
    Firestore db = Firestore.instance;

    Usuario motorista = await UsuarioFirebase.getDadosUsuarioLogado();
    motorista.latitude = _localMotorista.latitude;
    motorista.longitude = _localMotorista.longitude;

    db.collection("requisicoes")
      .document(idRequisicao)
      .updateData(
        {
          "motorista" : motorista.toMap(),
          "status" : StatusRequisicao.A_CAMINHO,
        }
      ).then((_) {
        String idPassageiro = _dadosRequisicao["passageiro"]["idUsuario"];
        db.collection("requisicao_ativa")
          .document(idPassageiro)
          .updateData({
            "status" : StatusRequisicao.A_CAMINHO,
        });

        String idMotorista = motorista.idUsuario;
        db.collection("requisicao_ativa_motorista")
          .document(idMotorista)
          .setData({
            "id_requisicao" : idRequisicao,
            "id_usuario" : idMotorista,
            "status" : StatusRequisicao.A_CAMINHO,
        });
      });

  }

  _statusaCaminho(){
    _alterarBotaPrincipal("A caminho do passageiro", Colors.grey, null);

    double latitudePassageiro = _dadosRequisicao["passageiro"]["latitude"];
    double longitudePassageiro = _dadosRequisicao["passageiro"]["longitude"];

    double latitudeMotorista = _dadosRequisicao["motorista"]["latitude"];
    double longitudeMotorista = _dadosRequisicao["motorista"]["longitude"];

    _exibirDoisMarcadores(LatLng(latitudeMotorista, longitudeMotorista), LatLng(latitudePassageiro, longitudePassageiro));
  }

  _exibirDoisMarcadores(LatLng motorista, LatLng passageiro){
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    Set<Marker> _listaMarcadores = {};

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/motorista.png")
        .then((BitmapDescriptor icone) {
      Marker marcadorMotorista = Marker(
          markerId: MarkerId("marcador-motorista"),
          position: LatLng(motorista.latitude, motorista.longitude),
          infoWindow: InfoWindow(title: "Local motorista"),
          icon: icone);
      _listaMarcadores.add(marcadorMotorista);
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/passageiro.png")
        .then((BitmapDescriptor icone) {
      Marker marcadorPassageiro = Marker(
          markerId: MarkerId("marcador-passageiro"),
          position: LatLng(passageiro.latitude, passageiro.longitude),
          infoWindow: InfoWindow(title: "Local passageiro"),
          icon: icone);
      _listaMarcadores.add(marcadorPassageiro);
    });

    setState(() {
      _marcadores = _listaMarcadores;
      _movimentarCamera(CameraPosition(
        target: LatLng(motorista.latitude, motorista.longitude),
        zoom: 18
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();

    _recuperarRequisicao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("painel motorista"),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              mapType: MapType.normal,
              //myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _marcadores,
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: Platform.isIOS
                    ? EdgeInsets.fromLTRB(20, 10, 20, 25)
                    : EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed: _funcaoBotao,
                  child: Text(
                    _textoBotao,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: _corBotao,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}