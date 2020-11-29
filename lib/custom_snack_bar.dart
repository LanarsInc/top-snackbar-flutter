import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSnackBar extends StatefulWidget {
  final String message;

  CustomSnackBar({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  _CustomSnackBarState createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 8.0),
            blurRadius: 20.0,
          ),
        ],
      ),
      width: double.infinity,
      child: Text(
        widget.message,
        style: theme.textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
    );
  }
}
