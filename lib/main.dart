import 'package:flutter/material.dart';
import 'package:pokedex/home.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

 class MyApp extends StatelessWidget {
   const MyApp({super.key});
 
   @override
   Widget build(BuildContext context) {
     return MaterialApp(routes: {homePage.route:(context) => const homePage()},initialRoute: homePage.route,);
   }
 }