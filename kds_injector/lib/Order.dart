import 'dart:math';
import 'dart:ui';
import 'package:kds_injector/Item.dart';
import 'Item.dart';

class Order {
  Order(this.orderNumber, this.quantity, this.bumped, this.items, this.time);

  int orderNumber;
  int quantity;
  bool bumped;
  List<Item> items;
  int time;

  static Order generateRandomOrder() {
    List<Item> items = [];
    var numItems = Random().nextInt(3) + 1;
    int orderNumber = Random().nextInt(1000);
    for (int i = 0; i < numItems; i++) {
      Item item = Item.generateRandomItem(orderNumber);
      items.add(item);
    }
    bool bumped = false;
    int quantity = numItems;
    return Order(orderNumber, quantity, bumped, items, currentTime());
  }

  static int currentTime() {
    int ms = DateTime.now().millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  static Map<String, dynamic> convertItemToMap(Item item) {
    Map<String, dynamic> map = {
      "name": item.name,
      "modifiers": item.modifiers,
      "checked": item.checked,
      "bumped": item.orderBumped,
      "orderNumber": item.orderNumber,
      "routingGroup": item.routingGroup,
    };
    return map;
  }

  static Map<String, dynamic> convertOrderToMap(Order order) {
    List<Map<dynamic, dynamic>> items = [];
    order.items.forEach((item) {
      items.add(convertItemToMap(item));
    });
    Map<String, dynamic> map = {
      "bumped": order.bumped,
      "items": items,
      "orderNumber": order.orderNumber,
      "quantity": order.quantity,
      "time": order.time,
    };
    return map;
  }

  @override
  int get hashCode => hashValues(orderNumber, quantity);
}