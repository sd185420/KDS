import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integrated_kds/buildLayout.dart';
import 'firebase_options.dart';
import 'menuBar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "swag",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String title = 'KDS App';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
          primaryColor: Colors.grey,
          scaffoldBackgroundColor: Color(0xffCCCCCC)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Active"),
      body: layout(
        bumpState: false,
        group: groups[0],
      ),
      bottomNavigationBar: MyBottomBar(),
    );
    // return Scaffold(
    // );
  }
}
