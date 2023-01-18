import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:glong_ya_connect/Konstants/konstants.dart';
import 'package:glong_ya_connect/Utilities/local_data_provider.dart';
import 'package:provider/provider.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    K k = K();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connection and Upload"),
      ),
      body: FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _bluetoothEnabled(k);
          } else {
            return _bluetoothWaiting();
          }
        },
      ),
    );
  }

  Widget _bluetoothWaiting() {
    return const Center(
      child: Icon(
        Icons.bluetooth_disabled,
        size: 20,
      ),
    );
  }

  void _send() async {
    String data = await Provider.of<LocalDataProvider>(context, listen: false).formatedDatabase();
  }

  Widget _bluetoothEnabled(K k) {
    return FutureBuilder(
      future: FlutterBluetoothSerial.instance.getBondedDevices(),
      builder: (BuildContext context, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              k.gap(size: 40),
              ListView(
                children: snapshot.data!
                    .map(
                      (BluetoothDevice d) => ListTile(
                        onTap: () {
                          _send();
                        },
                        title: Text(
                          d.name ?? "",
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          );
        } else {
          return const Center(
            child: Icon(Icons.bluetooth_searching),
          );
        }
      },
    );
  }
}
