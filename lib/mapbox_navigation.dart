import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapboxNavigation{
   MethodChannel _channel = const MethodChannel('flutter_mapbox_navigation');

   Future<String> get platformVersion async{
     final String version = await _channel.invokeMethod('getPlatformVersion');
     return version;
   }

   Future startNavigation(Location origin, Location destination) async{
      assert(origin != null);
      assert(origin.name != null);
      assert(origin.latitude != null);
      assert(origin.longitude != null);
      assert(destination != null);
      assert(destination.name != null);
      assert(destination.latitude != null);
      assert(destination.longitude != null);

      final Map<String, Object> args = <String, dynamic>{
         "originName": origin.name,
         "originLatitude": origin.latitude,
         "originLongitude": origin.longitude,
         "destinationName": destination.name,
         "destinationLatitude": destination.latitude,
        "destinationLongitude": destination.longitude
      };
      await _channel.invokeMethod('startNavigation', args);

   }
}

class Location{
  final String name;
  final double latitude;
  final double longitude;
  Location(
      {@required this.name, @required this.latitude, @required this.longitude});
}

class NavigationView extends StatefulWidget {
  final Location origin;
  final Location destination;
  NavigationView({@required this.origin, @required this.destination});
  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  Map<String, Object>  args;
  @override
  void initState() {
    args  = <String, dynamic>{
      "originName": widget.origin.name,
      "originLatitude": widget.origin.latitude,
      "originLongitude": widget.origin.longitude,
      "destinationName": widget.destination.name,
      "destinationLatitude": widget.destination.latitude,
      "destinationLongitude": widget.destination.longitude
    };

    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: 350,
      child: UiKitView(
        viewType:'FlutterMapboxNavigationView',
        creationParams: args,
        creationParamsCodec:StandardMessageCodec()
      ),
    );
  }
}