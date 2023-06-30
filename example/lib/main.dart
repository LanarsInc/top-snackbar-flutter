import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late AnimationController localAnimationController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.orangeAccent),
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
                        Overlay.of(context),
                        const CustomSnackBar.info(
                          message:
                              'There is some information. You need to do something with that',
                        ),
                      );
                    },
                    child: buildButton(context, 'Show info'),
                  ),
                  const SizedBox(height: 24),
                  TapBounceContainer(
                    onTap: () {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.success(
                          message:
                              'Good job, your release is successful. Have a nice day',
                        ),
                      );
                    },
                    child: buildButton(context, 'Show success'),
                  ),
                  const SizedBox(height: 24),
                  TapBounceContainer(
                    onTap: () {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message:
                              'Something went wrong. Please check your credentials and try again',
                        ),
                      );
                    },
                    child: buildButton(context, 'Show error'),
                  ),
                  const SizedBox(height: 48),
                  TapBounceContainer(
                    onTap: () {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                          message: 'Persistent SnackBar',
                        ),
                        persistent: true,
                        onAnimationControllerInit: (controller) {
                          localAnimationController = controller;
                        },
                      );
                    },
                    child: buildButton(context, 'Show persistent SnackBar'),
                  ),
                  const SizedBox(height: 24),
                  TapBounceContainer(
                    onTap: () => localAnimationController.reverse(),
                    child: buildButton(context, 'Dismiss persistent SnackBar'),
                  ),
                  const SizedBox(height: 24),
                  TapBounceContainer(
                    onTap: () {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                          message: 'Try to swipe me left',
                        ),
                        dismissType: DismissType.onSwipe,
                        dismissDirection: [DismissDirection.endToStart],
                      );
                    },
                    child: buildButton(
                      context,
                      'Show swiped dismissible SnackBar',
                    ),
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
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
