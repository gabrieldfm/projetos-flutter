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
  String _msgStatus;

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
      if (position != null) {
        
      }
    });
  }

  _recuperarUltimaLocalizacaoConhecida() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    if (position != null) {
      
    }
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _exibirMarcador(Position local, String icone, String infoWindow) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            icone)
        .then((BitmapDescriptor bitmapDescriptor) {
      Marker marcador = Marker(
          markerId: MarkerId(icone),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: infoWindow),
          icon: bitmapDescriptor);
      setState(() {
        _marcadores.add(marcador);
      });
    });
  }

  _recuperarRequisicao()async{

    String idRequisicao = widget.idRequisicao;
    Firestore db = Firestore.instance;

    DocumentSnapshot documentSnapshot = await db.collection("requisicoes")
      .document(idRequisicao)
      .get();
        
  }

  _adicionarListenerRequisicao() async{
    Firestore db = Firestore.instance;
    String idRequisicao = _dadosRequisicao["id"];
    await db.collection("requisicoes")
      .document(idRequisicao)
      .snapshots()
      .listen((snapshot) { 
        if (snapshot.data != null) {
          _dadosRequisicao = snapshot.data;
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

    double motoristaLat = _dadosRequisicao["motorista"]["latitude"];
    double motoristaLon = _dadosRequisicao["motorista"]["longitude"];
    Position position = Position(
      latitude: motoristaLat, longitude: motoristaLon
    );

    _exibirMarcador(position, "imagens/motorista.png", "Motorista");

    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);
    _movimentarCamera(cameraPosition);
  }
  
  _aceitarCorrida()async{
    String idRequisicao = _dadosRequisicao["id"];
    Firestore db = Firestore.instance;

    Usuario motorista = await UsuarioFirebase.getDadosUsuarioLogado();
    motorista.latitude = _dadosRequisicao["motorista"]["latitude"];
    motorista.longitude = _dadosRequisicao["motorista"]["longitude"];

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
    _msgStatus = "A caminho do passageiro";
    _alterarBotaPrincipal("Iniciar corrida", Color(0xff1ebbd8), (){
      _iniciarCorrida();
    });

    double latitudePassageiro = _dadosRequisicao["passageiro"]["latitude"];
    double longitudePassageiro = _dadosRequisicao["passageiro"]["longitude"];

    double latitudeMotorista = _dadosRequisicao["motorista"]["latitude"];
    double longitudeMotorista = _dadosRequisicao["motorista"]["longitude"];

    _exibirDoisMarcadores(LatLng(latitudeMotorista, longitudeMotorista), LatLng(latitudePassageiro, longitudePassageiro));

    var nLat, nLon, sLat, sLon;
    if (latitudeMotorista <= latitudePassageiro) {
      sLat = latitudeMotorista;
      nLat = latitudePassageiro;
    }else{
      sLat = latitudePassageiro;
      nLat = latitudeMotorista;
    }

    if (longitudeMotorista <= longitudePassageiro) {
      sLon = longitudeMotorista;
      nLon = longitudePassageiro;
    }else{
      sLon = longitudePassageiro;
      nLon = longitudeMotorista;
    }
    
    _movimentarCameraBounds(
      LatLngBounds(southwest: LatLng(sLat, sLon), northeast: LatLng(nLat, nLon))  
    );
  }

  _iniciarCorrida(){

  }

  _movimentarCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(
          CameraUpdate.newLatLngBounds(latLngBounds, 100)
        );
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
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerRequisicao();

    _recuperarUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();    
    //_recuperarRequisicao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("painel corrida - " + _msgStatus),
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