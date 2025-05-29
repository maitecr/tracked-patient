import 'package:flutter/material.dart';

class Loadingscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text("Enviando localização..."),
    ),
    body: Center(
      child: CircularProgressIndicator(),
    ),
   );
  }
  
}