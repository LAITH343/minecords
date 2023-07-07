import 'package:flutter/material.dart';

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.center,
      ),
      margin: EdgeInsets.only(bottom: 80, left: 50, right: 50),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showInfoDialog(BuildContext context, String msg) {
  showAboutDialog(
    context: context,
    children: [
      Center(
        child: Text(msg),
      ),
    ],
  );
}

SizedBox loadingWidget = const SizedBox(
  width: 20,
  height: 20,
  child: CircularProgressIndicator(color: Colors.white),
);
