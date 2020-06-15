import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};
  CameraPosition _posicaoCamera = CameraPosition(
            target: LatLng(-28.669245, -49.389718),
            zoom: 10
          );

  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);
  }

  _movimentarCamera()async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        _posicaoCamera
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

  _carregarPolylines(){
    
    Set<Polyline> polylinesLocal = {};

    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline1"),
      color: Colors.red,
      width: 20,
      startCap: Cap.squareCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      points: [
        LatLng(-28.639245, -49.389714),
        LatLng(-28.639244, -49.389713),
        LatLng(-28.639241, -49.389712),
      ],
      consumeTapEvents: true,
      onTap: (){
        print("Clidado na Polyline");
      },
    );

    polylinesLocal.add(polyline);
    setState(() {
      _polylines = polylinesLocal;
    });
    
  }

  _recuperarLocalAtual()async{
    Position position =  await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    setState(() {
      _posicaoCamera = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17
      );
      _movimentarCamera();
    });

    //print(position.toString());
  }

  _adicionarListenerLocalizacao(){
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10
    );
    geolocator.getPositionStream(locationOptions).listen((Position position){
      Marker marcadorusuario = Marker(
        markerId: MarkerId("marcador-usuario"),
        position: LatLng(-28.669245, -49.389718),
        infoWindow: InfoWindow(
          title: "usu"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen
        ),
        //rotation: 45
        onTap: (){
          print("clicado");
        }
      );
      setState(() {
        //_marcadores.add(marcadorusuario);
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17
        );
        _movimentarCamera();
      });
    });
  }

  _recuperarLocalParaEndereco()async{
    List<Placemark> listaEnderecos = await Geolocator().placemarkFromAddress("Tv germano magrin");

    print(listaEnderecos.length.toString());

    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark item = listaEnderecos[0];
      print(item.administrativeArea.toString());
      print(item.country.toString());
    }
  }

  @override
  void initState(){
    super.initState();
    //_carregarMarcadores();
    //_carregarPolygons();
    //_carregarPolylines();
    //_recuperarLocalAtual();
    //_adicionarListenerLocalizacao();
    _recuperarLocalParaEndereco();
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
          initialCameraPosition: _posicaoCamera,
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: _marcadores,
          //polygons: _polygons,
          //polylines: _polylines,
        ),
      ),
    );
  }
}