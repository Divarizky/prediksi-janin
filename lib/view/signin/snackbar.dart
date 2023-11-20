import 'package:flutter/material.dart';
import 'package:janin/theme.dart';

void showTextMessage(context, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: navbarColor,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}