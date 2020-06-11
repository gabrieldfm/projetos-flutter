import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};

  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);
  }

  _movimentarCamera()async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(-28.619245, -49.389718),
          zoom: 10,
          tilt: 0,
          bearing: 30
        )
      )
    );
  }

  _carregarMarcadores(){
    
    Set<Marker> marcadoresLocal = {};

    Marker marcadorShopping = Marker(
      markerId: MarkerId("marcador-shopping"),
      position: LatLng(-28.669245, -49.389718),
      infoWindow: InfoWindow(
        title: "Shops"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen
      ),
      //rotation: 45
      onTap: (){
        print("clicado");
      }
    );

    Marker marcadorSegundo = Marker(
      markerId: MarkerId("marcador-shopping"),
      position: LatLng(-28.639245, -49.389714),
      infoWindow: InfoWindow(
        title: "Segundo lugar"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange
      )
    );
    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(marcadorSegundo);

    setState(() {
      _marcadores = marcadoresLocal;
    });
    
  }

  _carregarPolygons(){
    
    Set<Polygon> polygonsLocal = {};

    Polygon polygon = Polygon(
      polygonId: PolygonId("polygons1"),
      fillColor: Colors.green,
      strokeColor: Colors.red,
      strokeWidth: 10,
      points: [
        LatLng(-28.639245, -49.389714),
        LatLng(-28.639244, -49.389713),
        LatLng(-28.639241, -49.389712),
      ],
      consumeTapEvents: true,
      onTap: (){
        print("Clidado na area");
      },
      zIndex: 0
    );

    polygonsLocal.add(polygon);
    setState(() {
      _polygons = polygonsLocal;
    });
    
  }

  @override
  void initState(){
    super.initState();
    _carregarMarcadores();
    _carregarPolygons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapas"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _movimentarCamera,
        child: Icon(Icons.done),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(-28.669245, -49.389718),
            zoom: 10
          ),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          markers: _marcadores,
          polygons: _polygons,
        ),
      ),
    );
  }
}