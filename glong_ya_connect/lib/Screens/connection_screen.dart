import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:glong_ya_connect/Konstants/konstants.dart';
import 'package:glong_ya_connect/Utilities/local_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key, this.address = ""});
  final String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect and Upload"),
      ),
      body: FutureBuilder(
        future: FlutterBluetoothSerial.instance.state,
        initialData: BluetoothState.STATE_OFF,
        builder: (context, snapshot) {
          if (snapshot.data == BluetoothState.STATE_ON) {
            return _bluetoothEnabled(context, address);
          } else {
            return _bluetoothDisabled();
          }
        },
      ),
    );
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

  Future<void> _upload(BuildContext context, BluetoothConnection bluetooth) async {
    String data = await Provider.of<LocalDataProvider>(context, listen: false).formatedDatabase();
    bluetooth.output.add(ascii.encode(data));
    bluetooth.output.allSent.then((value) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Uploaded successfully",
      ).show();
    });
  }

  Future<BluetoothConnection?> _connect(BuildContext context, String address) async {
    try {
      return await BluetoothConnection.toAddress(address);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Address Error"),
        ),
      );
      return null;
    }
  }

  Widget _bluetoothEnabled(BuildContext context, String address) {
    K k = K();
    return FutureBuilder(
      future: _connect(context, address),
      builder: (BuildContext context, AsyncSnapshot<BluetoothConnection?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "GlongYa is connected and ready to be updated",
                style: k.style(),
              ),
              k.gap(size: 10),
              GestureDetector(
                onTap: () => _upload(context, snapshot.data!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: k.blue,
                  ),
                  child: const Text("Upload"),
                ),
              )
            ],
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.bluetooth_searching,
                  size: 60,
                ),
                Text("Bluetooth waiting for connection"),
              ],
            ),
          );
        }
      },
    );
  }
}
