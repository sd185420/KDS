import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'Order.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "swag-injector",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Future<void> readJson() async {
  final response = await rootBundle.loadString('lib/ticket.json');
  var outerList = json.decode(response)["orders"];

  for (int i = 0; i < outerList.length; i++) {
    var innerList = outerList[i]["Data"]["LineItems"];
    var orderNumber = outerList[i]["Data"]["TicketNumber"];
    for (int j = 0; j < innerList.length; j++) {
      print(
          "order number $orderNumber ${innerList[j]["Definition"]["ShortDescription"]}");
    }
  }
}

Future<void> generateOrders(int amount) async {
  DatabaseReference ref =
      FirebaseDatabase.instance.ref().child("Merchant/Store1/Orders");

  for (int i = 0; i < amount; i++) {
    Order order = Order.generateRandomOrder();
    Map map = Order.convertOrderToMap(order);
    Map<String, Map> orderMap = {order.hashCode.toString(): map};
    ref.update(orderMap);
  }
}

void clearData() {
  DatabaseReference ref =
      FirebaseDatabase.instance.ref().child("Merchant/Store1/Orders");

  ref.remove();
  print("cleared");
}

final textController = TextEditingController();

void generateDialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        widthFactor: 0.3,
        heightFactor: 0.4,
        child: Container(
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter the Amount of Orders to Generate",
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  int amount = 0;
                  try {
                    amount = int.parse(textController.value.text);
                  } catch (on) {
                    // Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Input valid number")));
                    return;
                  }
                  generateOrders(amount);
                  Navigator.pop(context);
                },
                color: Colors.black12,
                child: const Text(
                  "Generate",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: MaterialButton(
                onPressed: () {
                  readJson();
                },
                color: Colors.grey,
                child: const Text("Inject from Json"),
              ),
            ),
            SizedBox(
              width: 300,
              child: MaterialButton(
                onPressed: () {
                  generateDialog(context);
                },
                color: Colors.grey,
                child: const Text("Inject random data"),
              ),
            ),
            SizedBox(
              width: 300,
              child: MaterialButton(
                onPressed: () {
                  clearData();
                },
                color: Colors.grey,
                child: const Text("Clear"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
