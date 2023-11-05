import 'dart:convert';

import 'package:crash/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'Gyrometer.dart';

class Graph extends StatefulWidget {
  List<DataPoint> xData = List<DataPoint>.empty(growable: true);
  List<DataPoint> yData = List<DataPoint>.empty(growable: true);
  List<DataPoint> zData = List<DataPoint>.empty(growable: true);


  Graph({required this.xData,required this.yData, required this.zData});
  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {

  List<DataPoint> _xData = List<DataPoint>.generate(100, (index) => DataPoint(0,0));
  List<DataPoint> _yData = List<DataPoint>.generate(100, (index) => DataPoint(0,0));
  List<DataPoint> _zData = List<DataPoint>.generate(100, (index) => DataPoint(0,0));

  int i=0;
  sendData() async{
print("Sending Data");
    var body = jsonEncode({
      "x": _xData,
      "y": _yData,
      "z": _zData
    });
    http.Response ans =  await http.post(Uri.parse("https://e0ba-2409-40d0-13-328a-b919-83f0-d54a-4446.ngrok-free.app/api/"),
        headers: {
          "Content-Type": "application/json"
        }
        ,body: body);
    print(ans.body);
  }


  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((event) {
      if(i == 100){
        setState(() {
          i=0;
        });
      }else{
        setState(() {
          _xData[i] = DataPoint(i, event.x);
          _yData[i] = DataPoint(i, event.y);
          _zData[i] = DataPoint(i, event.z);
          i++;
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Container(
                padding: const EdgeInsets.all(9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Don't Suffer",
                      style: GoogleFonts.poppins(
                          fontSize: 35, fontWeight: FontWeight.w600),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.help))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Accelerometer",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Center(
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(),
                  series: <LineSeries<DataPoint, int>>[
                    LineSeries<DataPoint, int>(
                      dataSource: _xData,
                      color:Colors.red,
                      xValueMapper: (DataPoint point, _) => point.x,
                      yValueMapper: (DataPoint point, _) => point.y,
                      name: 'X',
                    ),
                    LineSeries<DataPoint, int>(
                      dataSource: _yData,
                      color:Colors.yellow,
                      xValueMapper: (DataPoint point, _) => point.x,
                      yValueMapper: (DataPoint point, _) => point.y,
                      name: 'Y',
                    ),
                    LineSeries<DataPoint, int>(
                      dataSource: _zData,
                      color: Colors.green,
                      xValueMapper: (DataPoint point, _) => point.x,
                      yValueMapper: (DataPoint point, _) => point.y,
                      name: 'Z',
                    ),
                  ],
                ),
              ),
            ]),
            Positioned(
              bottom: 0,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromRGBO(0, 232, 152, 1),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  MyApp()));
                          }, icon: Icon(Icons.home_filled)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
                      // Gyrometer icon
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Gyrometer()));
                          },
                          icon: const Icon(Icons.directions_walk)),

                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Graph(
                                      xData: _xData,
                                      yData: _yData,
                                      zData: _zData,
                                    )));
                          },
                          icon: const Icon(Icons.graphic_eq)),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class DataPoint {
  final int x;
  final double y;

  DataPoint(this.x, this.y);
}
