import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();

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
        ),
      ),
    );
  }
}