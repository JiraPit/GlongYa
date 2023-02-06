// ignore_for_file: unnecessary_cast, deprecated_member_use, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:glong_ya_connect/Konstants/konstants.dart';
import 'package:glong_ya_connect/Utilities/local_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ConnectionScreen extends StatelessWidget {
  ConnectionScreen({super.key});
  final fbp.FlutterBluePlus bluePlus = fbp.FlutterBluePlus.instance;
  final FlutterBluetoothSerial bluetoothSerial = FlutterBluetoothSerial.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect and Upload"),
      ),
      body: FutureBuilder(
        future: _initBluetooth(),
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return _bluetoothEnabled(context);
          } else {
            return _bluetoothDisabled();
          }
        },
      ),
    );
  }

  Future<bool> _initBluetooth() async {
    return await bluetoothSerial.isEnabled ?? false;
  }

  Widget _bluetoothDisabled() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.bluetooth_disabled,
            size: 60,
          ),
          Text("Bluetooth disabled")
        ],
      ),
    );
  }

  Future<List> _listDevices() async {
    try {
      await bluePlus.connectedDevices;
      List<BluetoothDevice> devices = await bluetoothSerial.getBondedDevices();
      return devices;
    } on PlatformException {
      debugPrint("Platform Exception");
    }
    return [];
  }

  Future<void> _upload(BuildContext context, BluetoothConnection connection) async {
    String data = await Provider.of<LocalDataProvider>(context, listen: false).formatDatabase();
    debugPrint(data);
    connection.output.add(ascii.encode(data));
    connection.output.allSent.then((value) async {
      await connection.finish();
      connection.dispose();
      Alert(
        context: context,
        type: AlertType.success,
        title: "Uploaded successfully",
      ).show();
    });
  }

  Future<BluetoothConnection?> _connect(BuildContext context, BluetoothDevice device) async {
    try {
      // var scanner = bluePlus.scan().listen((event) {});
      // scanner.onDone(() {
      //   debugPrint("done scanning");
      // });
      // scanner.cancel();
      BluetoothConnection bluetoothConnection = await BluetoothConnection.toAddress(device.address);
      return bluetoothConnection;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Can't connect to the device"),
        ),
      );
      return null;
    }
  }

  Widget _bluetoothEnabled(BuildContext context) {
    K k = K();
    return FutureBuilder(
      future: _listDevices(),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return ListView(
            children: snapshot.data!
                .map(
                  (e) => ListTile(
                    leading: Icon(
                      Icons.bluetooth,
                      size: 30,
                      color: (e.name == "HC-05") ? k.blue : Colors.grey,
                    ),
                    title: Text(e.name),
                    onTap: () async {
                      debugPrint((e as BluetoothDevice).address);
                      BluetoothConnection? connection = await _connect(context, e);
                      if (connection != null) {
                        await _upload(context, connection);
                      }
                    },
                  ),
                )
                .toList(),
          );
        } else {
          return Center(
            child: Text(
              "Loading...",
              style: k.style(),
            ),
          );
        }
      },
    );
  }
}
