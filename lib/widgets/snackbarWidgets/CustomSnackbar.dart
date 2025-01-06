
import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController CustomSnackbar({ required text, backgroundColor = Colors.indigoAccent}){
  return Get.rawSnackbar(
    messageText: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: backgroundColor,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
  );
}