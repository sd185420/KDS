import 'dart:ui';
import 'package:integrated_kds/Item.dart';

class Order {
  Order(this.orderNumber, this.bumped, this.items, this.color, this.time, this.key);

  int orderNumber;
  bool bumped;
  List<Item> items;
  Color color;
  String key;
  int time;
}
