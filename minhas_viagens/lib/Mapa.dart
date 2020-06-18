import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  CameraPosition _posicaoCamera = CameraPosition(
          target: LatLng(-23.55553, -23.55554),
          zoom: 18
        );
  Firestore _db = Firestore.instance;

  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  _adicionarMarcador(LatLng latLng)async{

    List<Placemark> listaEnderecos = await Geolocator().placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark endereco = listaEnderecos[0];
      String rua = endereco.thoroughfare;

      Marker marcador = Marker(
      markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
      position: latLng,
      infoWindow: InfoWindow(
          title: rua
        )
      );

      setState(() {
        _marcadores.add(marcador);

        Map<String, dynamic> viagem = Map();
        viagem["titulo"] = rua;
        viagem["latitude"] = latLng.latitude;
        viagem["longitude"] = latLng.longitude;

        _db.collection("viagens")
        .add(viagem);
      });
    }    
  }

  _movimentarCamera()async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        _posicaoCamera
      )
    );
  }

  _adicionarListenerLocalizacao(){
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high);
    geolocator.getPositionStream(locationOptions).listen((Position position){
      setState(() {
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18
        );
        _movimentarCamera();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa"),
      ),
      body: GoogleMap(
        markers: _marcadores,
        mapType: MapType.normal,
        initialCameraPosition: _posicaoCamera,
        onMapCreated: _onMapCreated,
        onLongPress: _adicionarMarcador,
      ),
    );
  }
}