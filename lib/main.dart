import 'dart:io';
import 'package:rentreerapide/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'helpers/consts.dart';
import 'helpers/mix_helper.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory document =  await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>(localStorageName);
  appDataBox      = Hive.box<String>(localStorageName);
  appData         = appDataBox.toMap();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  // final bool isValidToken;
  // MyApp(this.isValidToken);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // brightness: Brightness.light,
        canvasColor: Colors.transparent,
        primarySwatch: Colors.orange,
        fontFamily: "Montserrat",
      ),
      home: SplashScreen(),
    );
  }
}
