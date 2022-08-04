class Item {
  Item(this.name, this.modifiers, this.checked, this.orderBumped,
      this.orderNumber, this.routingGroup, this.key);

  String name;
  List<Object?> modifiers;
  bool checked;
  bool orderBumped;
  int orderNumber;
  String routingGroup;
  String key;
}
