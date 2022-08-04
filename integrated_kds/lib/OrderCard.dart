import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Order.dart';

class OrderCard extends StatefulWidget {
  late Order randOrder;
  late DatabaseReference ref;
  late String path;
  late String routingGroup;

  OrderCard(
      {Key? key,
      required this.randOrder,
      required this.ref,
      required this.path,
      required this.routingGroup})
      : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    Order randOrder = widget.randOrder;
    DatabaseReference ref = widget.ref;
    String path = widget.path;
    String routingGroup = widget.routingGroup;
    return Container(
      //eventually want to have random color here
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(1.0),


        child: Column(
          children: <Widget>[
            for (int i = 0; i < randOrder.items.length; i++)
              Container(
                decoration: BoxDecoration(
                    color: ((randOrder.items[i]).checked)
                        ? const Color(0xffEFEFF0)
                        : Colors.white,
                    border: const Border(
                        bottom:
                            BorderSide(width: 1.5, color: Color(0xffEFEFF0)))),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            (randOrder.items[i]).name,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          Checkbox(
                            //changes checkbox background
                            activeColor: const Color(0xffEFEFF0),
                            //just changes checkmarl color
                            checkColor: Colors.green,
                            value: (randOrder.items[i]).checked,
                            onChanged: (bool? value) {
                              setState(
                                () {
                                  print(randOrder.items[i].name);
                                  print(
                                      "${randOrder.items[i].checked} -> $value");

                                  (randOrder.items[i]).checked = value!;
                                  String orderKey = (randOrder).key;
                                  String itemKey = randOrder.items[i].key;
                                  ref
                                      .child("$path/$orderKey/items/$itemKey")
                                      .update({"checked": value});
                                  if ((randOrder.items[i]).checked) {
                                    bool allChecked = true;
                                    for (int k = 0;
                                        k < randOrder.items.length;
                                        k++) {
                                      if ((randOrder.items[k]).checked ==
                                          false) {
                                        allChecked = false;
                                        break;
                                      }
                                    }
                                    if (allChecked) {
                                      String key = (randOrder).key;
                                      randOrder.items.forEach((item) {
                                        if (item.routingGroup == routingGroup) {
                                          item.orderBumped = !item.orderBumped;
                                          ref
                                              .child(
                                                  "$path/$key/items/${item.key}")
                                              .update({
                                            "bumped": true
                                          });
                                        }
                                      });
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          // Spacer(),
                          const Padding(padding: EdgeInsets.only(left: 0)),
                          for (int j = 0;
                              j < (randOrder.items[i]).modifiers.length;
                              j++)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  '          ${(randOrder.items[i]).modifiers[j]}',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),

        // Row
      ), //Column
      //SizedBox
    );
  }
}
