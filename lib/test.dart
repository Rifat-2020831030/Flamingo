import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late String lat;
  late String long;

  Future<Position> getLocation() async {
    late String lat;
    late String long;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('Location service disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Location permission are denied');
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error('Location permission permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
        ),
        Center(
          child: ElevatedButton(
            onPressed: (){
              getLocation().then((value){
                lat = '${value.latitude}';
                long = '${value.longitude}';

                setState(() {
                  print(lat);
                  print(long);
                });
              });
            }, child: Text('Get location'),
          ),
        ),
        Center(
          child: Text('Current location'),
        ),
      ],
    );
  }
}