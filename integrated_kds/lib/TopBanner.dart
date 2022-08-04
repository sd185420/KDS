import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integrated_kds/Order.dart';

List<Color> arrColors = [
  Color.fromRGBO(76, 161, 223, 0.4),
  Color.fromRGBO(253, 241, 82, 0.4),
  Color.fromRGBO(236, 51, 49, 0.4)
];
Color activeColor = arrColors[0];
List<int> thresholds = [15, 30];
int _pos = 0;

class TopBanner extends StatefulWidget {
  late List<Order> orders;
  late Order randOrder;
  late DatabaseReference ref;
  late String path;
  late String routingGroup;

  TopBanner(
      {Key? key,
      required this.orders,
      required this.randOrder,
      required this.ref,
      required this.path,
      required this.routingGroup})
      : super(key: key);

  @override
  State<TopBanner> createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  Timer? timer;
  late DateTime dateTime = DateTime.now();

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          dateTime = DateTime.now();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Order randOrder = widget.randOrder;
    DatabaseReference ref = widget.ref;
    String path = widget.path;
    List<Order> orders = widget.orders;
    String routingGroup = widget.routingGroup;
    Duration duration = dateTime
        .difference(DateTime.fromMillisecondsSinceEpoch(randOrder.time * 1000));

    if (duration.inSeconds < thresholds[0]) {
      setState(() {
        activeColor = arrColors[0];
      });
    } else if (duration.inSeconds < thresholds[1]) {
      setState(() {
        activeColor = arrColors[1];
      });
    } else {
      setState(() {
        activeColor = arrColors[2];
      });
    }

      // width: 700,
      return GestureDetector(
        onTap: () {
          print("tapped");
          randOrder.bumped = !randOrder.bumped;
          // randOrder.items
          setState(() {
            String key = (randOrder).key;
            int i = 0;
            randOrder.items.forEach((item) {
              if (item.routingGroup == routingGroup) {
                item.orderBumped = !item.orderBumped;
                ref.child("$path/$key/items/${item.key}").update({"bumped": (item.orderBumped)});
              }
            });
            // ref.child("$path/$key").update({"bumped": randOrder.bumped});
            // orders.remove(randOrder);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: activeColor,
            border: Border.all(
                color: const Color.fromRGBO(62, 86, 109, 0.32), width: 1.5),
          ),
          //height of info box
          height: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_sharp,
                          size: 15, color: Color.fromRGBO(82, 82, 82, 1)),
                      Text(
                        //clock countdown
                        '${twoDigits(duration.inMinutes.remainder(60))} : ${twoDigits(duration.inSeconds.remainder(60))}',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            textStyle: const TextStyle(color: Color.fromRGBO(82, 82, 82, 1))),
                      )
                    ],
                  ),
                  Text(
                    //order number
                    'Order: ${randOrder.orderNumber.toString()}',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        textStyle: const TextStyle(
                            color: Color.fromRGBO(82, 82, 82, 1))),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notification_add_outlined,
                          size: 15, color: Color.fromRGBO(82, 82, 82, 1)),
                      Text(
                        'Dine In',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            textStyle: const TextStyle(
                                color: Color.fromRGBO(82, 82, 82, 1))),
                      ),
                    ],
                  ),
                  Text(
                    'User: Nathan',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        textStyle: const TextStyle(
                            color: Color.fromRGBO(82, 82, 82, 1))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}