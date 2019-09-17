import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:geolocator/geolocator.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Mapa()
      ),
    );
  }
}

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
 static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  Set<Marker> get markers => _markers;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async{
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print("initial position is : ${_initialPosition.toString()}");
    //Se encarga de mostrar en el campo de texto el nombre de
    // la ubicación del usuario
    locationController.text = placemark[0].name;
  }
  /* void _addMarker(LatLng location, String address){
     _markers.add(Marker(
       point: location,
       
        ));
      
   }*/

   void sendRequest(String intendedLocation)async{
     List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);

   }


  final origin = Location(name: "Izamal, Yucatan", latitude: 20.9345, longitude: -89.0182);
  final destination = Location(name: "Merida, Yucatan", latitude: 20.97, longitude: -89.62);

  //FlutterMapboxNavigation _mapboxNavigation = FlutterMapboxNavigation();
  //await FlutterMapboxNavigation.startNavigation(origin, destination);
  
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        FlutterMap(
          options: MapOptions(
            center: LatLng(20.9345, -89.0182),//20.9345, -89.0182
            zoom: 13.0,
          ),
          //mapController: MapController(),
          layers: [
            new TileLayerOptions(
              urlTemplate: "https://api.mapbox.com/v4/"
                  "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
              additionalOptions: {
                'accessToken': 'pk.eyJ1IjoiZW1hbnVlbDIyMTEiLCJhIjoiY2p6b2F2bHpoMGQxdjNocDRvMTlreHk0eiJ9.TiGJwVpLcdT3eAAmRgxyRg',
                'id': 'mapbox.streets',
              },
            ),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(destination.latitude,destination.longitude),
                  builder: (ctx) =>
                  new Container(
                    child: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.location_on,color: Colors.blue,),
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
                top: 50.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: locationController,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "pick up",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),
              //Aquí se escribe el lugar de la ruta de destino
              Positioned(
                top: 105.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: destinationController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      sendRequest(value);
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.local_taxi,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "destination?",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),
        Positioned(
          top: size.height * 0.5,
          left: size.width * 0.35,
          child: RaisedButton(
            onPressed: ()async{
              await FlutterMapboxNavigation.startNavigation(origin, destination);
             
            },
            child: Text('Navegar'),
          ),
        )
      ],
    );
    
    
  }
}