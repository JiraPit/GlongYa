// ignore_for_file: prefer_const_constructors

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:glong_ya_connect/Konstants/konstants.dart';
import 'package:glong_ya_connect/Utilities/LocalDataProvider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key, this.boxNumber = 1});
  final int boxNumber;

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    K k = K();
    String newMedicine = "";
    List<int> newTime = [];
    return Scaffold(
        backgroundColor: k.white,
        appBar: AppBar(title: const Text("Medicine Information")),
        body: FutureBuilder(
          initialData: const [
            {"medicine": "loading..."},
            {"hour": "loading..."},
            {"minute": "loading..."}
          ],
          future: Provider.of<LocalDataProvider>(context, listen: false)
              .database
              ?.rawQuery('SELECT * FROM glongya WHERE id = ${widget.boxNumber}'),
          builder: ((context, snapshot) {
            return Column(children: [
              k.gap(size: 20),
              _informationField(
                context,
                name: "Box",
                info: widget.boxNumber.toString(),
                editable: false,
              ),
              _informationField(
                context,
                name: "Medicine",
                info: snapshot.data![0]["medicine"].toString(),
                editPopup: () => _medicineEditPopup(context, newMedicine, k).show(),
              ),
              _informationField(
                context,
                name: "Time",
                info:
                    "${_formatTime(snapshot.data![0]["hour"])} : ${_formatTime(snapshot.data![0]["minute"])}",
                editPopup: () => _timeEditPopup(context, newTime, k).show(),
              ),
            ]);
          }),
        ));
  }

  Alert _medicineEditPopup(BuildContext context, String value2change, K k) {
    return Alert(
      context: context,
      title: "Medicine",
      buttons: [
        DialogButton(
          onPressed: () {
            setState(() {
              Provider.of<LocalDataProvider>(context, listen: false)
                  .modifyDatabase(id: widget.boxNumber, medicine: value2change);
            });
            Navigator.pop(context);
          },
          child: Text("Save", style: k.style()),
        ),
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: k.style()),
        ),
      ],
      content: TextField(
        onChanged: ((value) {
          if (value != "") {
            value2change = value;
          }
        }),
      ),
    );
  }

  Alert _timeEditPopup(BuildContext context, List<int> value2change, K k) {
    return Alert(
      context: context,
      title: "Time",
      buttons: [
        DialogButton(
          onPressed: () {
            setState(() {
              Provider.of<LocalDataProvider>(context, listen: false)
                  .modifyDatabase(id: widget.boxNumber, hour: value2change[0], minute: value2change[1]);
            });
            Navigator.pop(context);
          },
          child: Text("Save", style: k.style()),
        ),
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: k.style()),
        ),
      ],
      content: DateTimePicker(
        type: DateTimePickerType.time,
        onChanged: (newValue) {
          value2change = [
            int.parse(newValue.split(":")[0]),
            int.parse(newValue.split(":")[1]),
          ];
        },
      ),
    );
  }

  String _formatTime(Object? time) {
    debugPrint(time.toString());
    if (time.toString().length < 2) {
      return "0${time.toString()}";
    } else {
      return time.toString();
    }
  }

  Padding _informationField(
    BuildContext context, {
    String name = "",
    String info = "",
    bool editable = true,
    dynamic editPopup,
  }) {
    K k = K();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "$name: ",
                style: k.style(color: k.black, fontSize: 24),
              ),
              Text(
                info,
                style: k.style(color: k.blue, fontSize: 24, weight: FontWeight.bold),
              ),
            ],
          ),
          editable
              ? GestureDetector(
                  onTap: () {
                    if (editPopup != null) {
                      editPopup();
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: k.blue,
                      // borderRadius: k.roundedCorners(),
                    ),
                    child: Center(
                      child: Text(
                        "Edit",
                        style: k.style(weight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
