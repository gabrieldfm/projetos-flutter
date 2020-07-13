import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meu_carro/app/models/oficina_model.dart';

class MapaOficinaPage extends StatefulWidget {
  Oficina oficina;

  MapaOficinaPage(this.oficina);

  @override
  _MapaOficinaPageState createState() => _MapaOficinaPageState();
}

class _MapaOficinaPageState extends State<MapaOficinaPage> {
  Set<Marker> _marcadores = {};
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-26.0000, -240000));

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _recuperaOficina(Oficina oficina) async{

    String titulo = oficina.nome;
    LatLng latLng = LatLng(oficina.latitude, oficina.longitude);

    setState(() {
      Marker marcador = Marker(
        markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
        position: latLng,
        infoWindow: InfoWindow(
            title: titulo
          )
      );
      _marcadores.add(marcador);
      _posicaoCamera = CameraPosition(
        target: latLng,
        zoom: 18
      );
      _movimentarCamera();
    });    
  }

  _movimentarCamera()async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        _posicaoCamera
      )
    );
  }

  _adicionarMarcador(LatLng latLng)async{
    Oficina oficina = widget.oficina;
    String rua = oficina.rua;

    Marker marcador = Marker(
    markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
    position: latLng,
    infoWindow: InfoWindow(
        title: rua
      )
    );

    setState(() {
      _marcadores.add(marcador);
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaOficina(widget.oficina);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.oficina.nome),
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