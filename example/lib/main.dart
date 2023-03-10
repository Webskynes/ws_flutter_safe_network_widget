import 'package:flutter/material.dart';
import 'package:ws_flutter_safe_network_widget/ws_flutter_safe_network_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          body: Center(
        child: NetworkSafeWidget(
          alertType: NetworkAlertType.alert,
          showOnConnectionRestoredWidgets: true,
          child: const Text('Webskyne Flutter Network Widget'),
        ),
      )),
    );
  }
}
