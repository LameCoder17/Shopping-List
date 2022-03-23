import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shopping_list/Utils/Colors.dart';
import 'package:sizer/sizer.dart';
import 'Screens/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping List',
        home: LoginScreen(),
        themeMode: ThemeMode.dark,
      );
    });
  }
}