import 'dart:math';
import 'dart:ui';

class Item {
  Item(this.name, this.modifiers, this.checked, this.orderBumped,
      this.orderNumber, this.routingGroup);

  String name;
  List<Object?> modifiers;
  bool checked;
  bool orderBumped;
  int orderNumber;
  String routingGroup;

  Item.def()
      : name = "",
        modifiers = [],
        checked = false,
        orderBumped = false,
        orderNumber = 0,
        routingGroup = "";

  // }

  static List<String> items = [
    "Börger",
    "Pizza",
    "Ramen",
    "Spaghetti",
    "Ice Cream",
    "Chicken"
  ];

  static List<String> routingGroups = ["Dinners", "Drinks", "Lunches"];

  static List<List<String>> modifiersList = [
    ["Mod1", "Mod2", "Mod3"],
    ["Mod4", "Mod5", "Mod6"]
  ];

  static Item generateRandomItem(orderNumber) {
    String name = items[Random().nextInt(items.length)];
    String routingGroup = routingGroups[Random().nextInt(routingGroups.length)];
    List<String> modifiers =
        modifiersList[Random().nextInt(modifiersList.length)];
    //when order is created it should be active and unchecked
    bool orderBumped = false;
    bool checked = false;
    return Item(
      name,
      modifiers,
      checked,
      orderBumped,
      orderNumber,
      routingGroup,
    );
  }
}
