import 'package:flutter/material.dart';
import 'package:package_tracker/widgets/HomeWidget.dart';
import 'dart:async';

import 'package:package_tracker/widgets/InstructionWidget.dart';

import 'dbTool.dart';

late dataStore db;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = await dataStore.create();

  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Package Tracker',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
        ),
        home: const MainApp(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeWidget(parentCtx: context, db: db,),
          '/splash': (BuildContext context) => InstructionWidget(parentCtx: context),
        }
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State createState() => MainState();

  static MainState of(BuildContext context) => context.findAncestorStateOfType<MainState>()!;
}

class MainState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  Future checkFirstSeen() async {

    bool firstTime = true; //(db.getPref('show_instruction')) ?? true;

    if (firstTime) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/splash', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context){
    Timer(const Duration(milliseconds: 10), () {
      checkFirstSeen();
    });
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Center(
                    child: Text("Hello World")
                    /*Image(
                      image: AssetImage('assets/my_icon.png'),
                      width: 150,
                    )
                    */
                ),
              ),
            ]
        )
    );
  }
}