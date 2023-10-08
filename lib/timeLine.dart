import 'package:bottom_picker/bottom_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:bottom_picker/resources/arrays.dart';

class TimeLine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DataLoadingState();
  }
}

class _DataLoadingState extends State<TimeLine> {
  late List<List<dynamic>> _data = [];
  List<Marker> markers = [];
  String country = 'USA', time = '2023-01-01';

  load(String s1, String s2) async {
    String url =
        "https://firms.modaps.eosdis.nasa.gov/api/country/csv/e435c561b12fd724d1bd8d6d7462b1aa/VIIRS_SNPP_NRT/" +
            s1 +
            "/1/" +
            s2 +
            "/?=e435c561b12fd724d1bd8d6d7462b1aa";
    var response = await http.get(Uri.parse(url));
    print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200) {
      String csv = response.body.toString();
      _data = const CsvToListConverter().convert(csv);

      List<LatLng> tempMarker =
          []; // Create a temporary list to store LatLng values

      double lat = 0;
      double lon = 0;
      print("$country $time $_data[0].length");
      print("$s1 $s2 ");
      var innerList = _data[0];
      for (var j = 15; j < innerList.length; j++) {
        var element =
            innerList[j]; // Access the element within the inner list at index
        if (j % 14 == 1) {
          lat = element.toDouble();
        }
        if (j % 14 == 2) {
          lon = element.toDouble();
          print("$lat $lon");
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
              child: Image.asset('imagess/wave.gif'),
            ),
          ),
        );
      }

      setState(() {
        // _data = _data;
        markers = markers;
        // marker = tempMarker; // Update the marker list with the values
      });
    } else
      print("data loading failed");
    return "";
  }

  void BottomPicking(BuildContext context) {
    BottomPicker.date(
      title: 'Select a Date',
      dateOrder: DatePickerDateOrder.ymd,
      pickerTextStyle: const TextStyle(
          color: Colors.black26, fontWeight: FontWeight.bold, fontSize: 18),
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      onSubmit: (index) {
        print(index.toString());
        time = index.toString();
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }

  String modify(String name) {
    if (name == "AF")
      country = 'AFG';
    else if (name == "AU")
      country = 'AUS';
    else if (name == "BD")
      country = 'BGD';
    else if (name == "BR")
      country = 'BRA';
    else if (name == "CA")
      country = 'CAN';
    else if (name == "CN")
      country = 'CHN';
    else if (name == "ES")
      country = 'ESP';
    else if (name == "FR")
      country = 'FRA';
    else if (name == "GB")
      country = 'GBR';
    else if (name == "IN")
      country = 'IND';
    else if (name == "NP")
      country = 'NPL';
    else if (name == "US") country = 'USA';

    return country;
  }

  int date = 1;

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
                center:
                    LatLng(double.parse("22.937620"), double.parse("78.856387")),
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
              bottom: 20.0,
              left: 100.0,
               child: ElevatedButton(
                          onPressed: () {
                            BottomPicking(context); // time picking
                            showCountryPicker(
                              context: context,
                              onSelect: (Country value) {
                                //print(value.countryCode.toString());
                                country = value.countryCode.toString();
                                country = modify(country); //country picking
                                markers.clear();
                                load(country,
                                    time); // load new api marker based on country and time
                              },
                            );
                          },
                          child: Text('Pick Date and Country'),
                        ),
             ),
          ],
        ));
  }
}
