import 'package:flutter/material.dart';
import 'package:glong_ya/Konstants/konstants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    K k = K();
    return Scaffold(
      backgroundColor: k.blue,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          k.gap(size: 40),
          ComingUp(),
          k.gap(size: 30),
          Container(
            height: 470,
            width: double.infinity,
            decoration: BoxDecoration(
              color: k.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [k.gap(size: 20)] +
                    [1, 2, 3, 1, 1, 1, 1, 1, 1]
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: BoxInfo(
                                boxNumber: e,
                              ),
                            ))
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ComingUp extends StatelessWidget {
  const ComingUp({super.key});

  @override
  Widget build(BuildContext context) {
    K k = K();
    return Container(
      height: 320,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: k.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "In the next",
            style: k.style(
              color: k.black,
              fontSize: 20,
            ),
          ),
          k.gap(size: 15),
          Text(
            "5 : 00",
            style: k.style(
              color: k.blue,
              fontSize: 80,
              weight: FontWeight.bold,
            ),
          ),
          k.gap(size: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Med:  ",
                style: k.style(
                  color: k.black,
                  fontSize: 20,
                ),
              ),
              Text(
                "Parabola",
                style: k.style(
                  color: k.blue,
                  weight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BoxInfo extends StatelessWidget {
  const BoxInfo({
    super.key,
    this.boxNumber = 0,
  });

  final int boxNumber;

  @override
  Widget build(BuildContext context) {
    K k = K();
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: k.white,
        borderRadius: k.roundedCorners(radius: 20),
        boxShadow: k.shadows(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          k.gap(size: 5),
          Text(
            "Box $boxNumber",
            style: k.style(color: k.black),
          ),
          k.gap(size: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Medicine: Parabola", style: k.style(color: k.black)),
              k.gap(size: 10),
              Text("Time: 14.00", style: k.style(color: k.black)),
            ],
          ),
          k.gap(size: 15),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: k.blue,
                borderRadius: k.roundedCorners(),
              ),
              child: Center(
                child: Text(
                  "Edit",
                  style: k.style(weight: FontWeight.bold),
                ),
              ),
            ),
          ),
          k.gap(size: 5)
        ],
      ),
    );
  }
}
