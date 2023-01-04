// ignore_for_file: prefer_const_constructors

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
    String value2change = "";
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
              informationField(
                context,
                name: "Box",
                info: widget.boxNumber.toString(),
                editable: false,
              ),
              informationField(
                context,
                name: "Medicine",
                info: snapshot.data![0]["medicine"].toString(),
                editPopup: () {
                  Alert(
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
                  ).show();
                },
              ),
              informationField(
                context,
                name: "Time",
                info: "${snapshot.data![0]["hour"]} : ${snapshot.data![0]["minute"]}",
              ),
            ]);
          }),
        ));
  }

  Padding informationField(
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
