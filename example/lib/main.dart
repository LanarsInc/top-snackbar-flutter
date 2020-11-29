import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Center(
              child: FlatButton(
                color: Colors.blueAccent,
                child: Text(
                  "Show snack bar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    showTopSnackBar(
                      context,
                      CustomSnackBar(
                        message: "Error message!",
                      ),
                    );
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
