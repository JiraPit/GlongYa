import 'package:flutter/material.dart';
import 'package:glong_ya_connect/Konstants/konstants.dart';
import 'package:glong_ya_connect/Screens/information.dart';
import 'package:glong_ya_connect/Screens/connection_screen.dart';
import 'package:glong_ya_connect/Utilities/local_data_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    K k = K();
    Provider.of<LocalDataProvider>(context).formatDatabase();
    String bluetoothAddress = "";
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(title: const Text("Glong Ya")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
              ),
              child: Column(
                children: [k.gap(size: 10)] +
                    [1, 2, 3]
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: BoxInfo(
                                boxNumber: e,
                              ),
                            ))
                        .toList() +
                    [
                      k.gap(size: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 220,
                            child: TextField(
                              decoration: const InputDecoration(labelText: "Bluetooth Address"),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  bluetoothAddress = value;
                                }
                              },
                            ),
                          ),
                          k.gap(size: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConnectionScreen(
                                    address: bluetoothAddress,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              decoration: BoxDecoration(color: k.blue),
                              child: Text(
                                "Upload",
                                style: k.style(fontSize: 20, weight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxInfo extends StatelessWidget {
  const BoxInfo({super.key, this.boxNumber = 1});

  final int boxNumber;

  @override
  Widget build(BuildContext context) {
    K k = K();
    var db = Provider.of<LocalDataProvider>(context).database;
    if (db != null) {
      return Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: k.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            k.gap(size: 15),
            Text(
              "Box $boxNumber",
              style: k.style(color: k.black),
            ),
            k.gap(size: 15),
            SizedBox(
              width: 160,
              child: FutureBuilder(
                initialData: const [
                  {"medicine": "loading..."},
                  {"hour": "loading..."},
                  {"minute": "loading..."}
                ],
                future: db.rawQuery('SELECT * FROM glongya WHERE id = $boxNumber'),
                builder: ((context, snapshot) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Medicine: ${snapshot.data![0]["medicine"]}",
                        style: k.style(color: k.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      k.gap(size: 10),
                      Text(
                          "Time: ${_formatTime(snapshot.data![0]["hour"])}:${_formatTime(snapshot.data![0]["minute"])}",
                          style: k.style(color: k.black)),
                    ],
                  );
                }),
              ),
            ),
            k.gap(size: 15),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationScreen(boxNumber: boxNumber)),
                );
              },
              child: Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: k.blue,
                  borderRadius: k.roundedCorners(radius: 0),
                ),
                child: Center(
                  child: Text(
                    "Edit",
                    style: k.style(weight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            k.gap(size: 15)
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  String _formatTime(Object? time) {
    if (time.toString().length < 2) {
      return "0${time.toString()}";
    } else {
      return time.toString();
    }
  }
}
