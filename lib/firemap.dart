import 'package:data_vis/bot.dart';
import 'package:data_vis/timeline3d.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math' as math;

class Map extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DataLoadingState();
  }
}

class _DataLoadingState extends State<Map> {
  LatLng currentAdrs = const LatLng(23.767382, 90.421688);
  double min = 1e10;
  List<LatLng> tempMarker = [
    LatLng(22.20376, 91.99538),
    LatLng(22.7409, 91.85969),
    LatLng(23.37282, 90.86424),
    LatLng(24.86623, 92.01669),
    LatLng(22.47243, 91.73368),
    LatLng(22.47798, 91.735),
    LatLng(22.53636, 91.69823),
    LatLng(22.53834, 91.70058),
    LatLng(23.69393, 90.51213),
    LatLng(24.63724, 91.66256),
    LatLng(24.91011, 91.82801),
    LatLng(25.76299, 88.84071),
  ];
  // map code
  late List<List<dynamic>> _data = [];
  List<Marker> markers = [];

  @override
  void initState() {
    load();
    cal();

    // TODO: implement initState
    super.initState();
  }

  // api call
  load() async {
    String url =
        "https://firms.modaps.eosdis.nasa.gov/api/country/csv/e435c561b12fd724d1bd8d6d7462b1aa/VIIRS_SNPP_NRT/BAN/1/2023-01-01/?=e435c561b12fd724d1bd8d6d7462b1aa";
    var response = await http.get(Uri.parse(url));
    //print(response.body);
    if (response.statusCode == 200) {
      String csv = response.body.toString();
      _data = const CsvToListConverter().convert(csv);

      double lat = 0;
      double lon = 0;
      var innerList = _data[0];
      for (var j = 15; j < innerList.length; j++) {
        var element =
            innerList[j]; // Access the element within the inner list at index
        if (j % 14 == 1) {
          lat = element.toDouble();
        }
        if (j % 14 == 2) {
          lon = element.toDouble();
          // print("$lat $lon");
          tempMarker.add(LatLng(lat, lon));
        }
      }
      for (var data in tempMarker) {
        markers.add(
          Marker(
            width: 50.0,
            height: 50.0,
            point: LatLng(data.latitude, data.longitude),
            builder: (ctx) => Container(
              child: Image.asset('assets/images/firefire.gif'),
            ),
          ),
        );
      }
      markers.add(
        Marker(
            width: 50.0,
            height: 50.0,
            point: LatLng(currentAdrs.latitude, currentAdrs.longitude),
            builder: (ctx) => Container(
              child: Image.asset('assets/images/location.png'),
            ),
          ),
      );

      setState(() { 
        //_data = _data;
        markers = markers;
        // marker = tempMarker; // Update the marker list with the values
      });
    } else
      print("data loading failed");
    return "";
  }

  // live location
  Future<Position> getLocation() async {
    late String lat;
    late String long;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  //radian function
  double radians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  //distance function
  double calculateDistance(double lat1, double lon1) {
    const radius = 6371; // Earth's radius in kilometers

    final dLat = radians(currentAdrs.latitude - lat1).abs();
    final dLon = radians(currentAdrs.longitude - lon1).abs();

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(radians(lat1)) *
            math.cos(radians(currentAdrs.latitudeInRad)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    final distance = radius * c; // Distance in kilometers
    return distance;
  }

  // minumum distance from fire
  void cal() {
    for (var data in tempMarker) {
      var distance = calculateDistance(data.latitude, data.longitude);
      if (distance < min) min = distance;

      print(distance);
    }
    print('min distance -> $min');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('F L A M I N G O'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 47, 55, 75),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              //center: point,
              center: LatLng(currentAdrs.latitude, currentAdrs.longitude),
              zoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: markers)
            ],
          ),
          Positioned(
            right: 10.0,
            top: 20.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      //for reporting
                      heroTag: 'btn1',
                      backgroundColor: Color.fromARGB(255, 47, 55, 75),
                      child: Icon(Icons.report),
                      onPressed: () {
                        //load("USA");
                        //print(_data);
                      }),
                ),
                FloatingActionButton(
                    // for chatbot
                    heroTag: 'btn2',
                    backgroundColor: Color.fromARGB(255, 47, 55, 75),
                    child: Image.asset(
                      'assets/images/technical.png',
                      height: 30,
                      width: 30,
                    ),
                    onPressed: () {
                      //print("Chat Bot requested");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatBot(),
                          ));
                    }),
              ],
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 10.0,
            child: FloatingActionButton(
              //for 3d view
              heroTag: 'btn3',
              backgroundColor: Color.fromARGB(255, 47, 55, 75),
              child: Image.asset(
                'assets/images/view.png',
                height: 45,
                width: 45,
              ),
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(),
                      ));
              },
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton(
              //for live location
              heroTag: 'btn4',
              backgroundColor: Color.fromARGB(255, 47, 55, 75),
              child: Image.asset(
                'assets/images/map.png',
                height: 45,
                width: 45,
              ),
              onPressed: () {
                getLocation().then(
                  (value) {
                    var lat = value.latitude, lon = value.longitude;
                    setState(
                      () {
                        currentAdrs = LatLng(lat, lon);
                        print('lat -> $lat');
                        print(lon);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
