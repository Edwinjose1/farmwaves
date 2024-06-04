// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Notificaionpage extends StatefulWidget {
  const Notificaionpage({super.key});

  @override
  State<Notificaionpage> createState() => _NotificaionpageState();
}

class _NotificaionpageState extends State<Notificaionpage> {
  String message = "";


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final arguments=ModalRoute.of(context)!.settings.arguments;
    if(arguments!=null){
      Map? pushargumetns=arguments as Map;
      setState(() {
        message=pushargumetns["message"];
      });

    }

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Container(
          child: const Text("Push Message :"),
        ),
      ),
    ));
  }
}
