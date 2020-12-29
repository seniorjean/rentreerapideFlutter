import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

final String localStorageName = "myAppData";
Box<String> appDataBox;
var appData = {};
final String appTitle = 'RentreeRapide';

Map parentDetails = {};
Map userDetails   = {};

var reload = false;

var is_app_connected;

Color BACKGROUND_COLOR = Color(0xFFF5F5F5);

Widget loadingImageError = Center(child: Icon(Icons.error));

//====================================================\\



