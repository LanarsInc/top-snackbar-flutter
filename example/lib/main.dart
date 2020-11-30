import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';

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
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
      ),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TapBounceContainer(
                    onTap: () {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.info(
                          message:
                              "There is some information. You need to do something with that",
                        ),
                      );
                    },
                    child: buildButton(context, "Show info"),
                  ),
                  SizedBox(height: 24),
                  TapBounceContainer(
                    onTap: () {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.success(
                          message:
                              "Good job, your release is successful. Have a nice day",
                        ),
                      );
                    },
                    child: buildButton(context, "Show success"),
                  ),
                  SizedBox(height: 24),
                  TapBounceContainer(
                    onTap: () {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message:
                              "Something went wrong. Please check your credentials and try again",
                        ),
                      );
                    },
                    child: buildButton(context, "Show error"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container buildButton(BuildContext context, String text) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 6,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
