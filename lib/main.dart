import 'package:flutter/material.dart';
import 'page/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //primary color 속성이 사라졌으니 이제 ColorScheme.light를 이용할 것
        colorScheme: ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}