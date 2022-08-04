import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:integrated_kds/menuBar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Item.dart';
import 'Order.dart';
import 'TopBanner.dart';
import 'OrderCard.dart';

List<Order> orders = <Order>[];
final controller = ScrollController();
String path = "Merchant/Store1/Orders";
late Item item;

final int DISPLAYCAP = 8;

String twoDigits(int n) => n.toString().padLeft(2, '0');

class layout extends StatefulWidget {
  bool bumpState = false;
  String group = "";

  layout({Key? key, required this.bumpState, required this.group})
      : super(key: key);

  @override
  State<layout> createState() => _layoutState();
}

class _layoutState extends State<layout> {

  @override
  Widget build(BuildContext context) {
    print("building");
    return Scaffold(
      body: buildOrders(),
    );
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Widget buildOrders() {
    return StreamBuilder(
        stream: ref.child(path).onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("LOADING...");
            return const Center(child: CircularProgressIndicator());
          }

          orders = [];
          if (snapshot.data!.snapshot.value != null) {
            var snap = snapshot.data!.snapshot.value as Map;
            // print(snap);
            if (snap != null) {
              snap.forEach(
                (key, value) {
                  int orderNumber = value["orderNumber"];
                  bool bumped = value["bumped"];
                  int time = value["time"];
                  List<Item> items = <Item>[];

                  int i = 0;
                  value["items"].forEach((itemObject) {
                    if (itemObject["routingGroup"] == widget.group && itemObject["bumped"] == bumpState) {
                      items.add(Item(
                          itemObject["name"],
                          itemObject["modifiers"],
                          itemObject["checked"],
                          itemObject["bumped"],
                          itemObject["orderNumber"],
                          itemObject["routingGroup"],
                          i.toString()));
                    }
                    i++;
                  });

                  // if (bumpState == bumped) {
                    if (items.isNotEmpty) {
                      // print(items[0].name);
                      Order order = Order(
                          orderNumber, bumped, items, Colors.grey, time, key);
                      orders.add(order);
                    }
                  // }
                },
              );
            }
          }
          return buildGridView();
        });
  }

  Widget buildGridView() => GridView.builder(

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: .75,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,

        ),
        padding: const EdgeInsets.all(4),
        controller: controller,
        // scrollDirection: Axis.fihorizontal,
        itemCount: min(orders.length, DISPLAYCAP),
        itemBuilder: (context, index) {
          return buildNumber(orders, index, ref, path);
        },
      );

  Widget buildNumber(
      List<Order> orders, int index, DatabaseReference ref, String path) {
    if (orders.isEmpty) {
      return Container();
    }
    Order randOrder = orders[index];

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 350,
      //padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TopBanner(orders: orders, randOrder: randOrder, ref: ref, path: path,routingGroup: widget.group,),
          OrderCard(randOrder: randOrder, ref: ref, path: path, routingGroup: widget.group,),
        ],
      ),
    );
  }
}
