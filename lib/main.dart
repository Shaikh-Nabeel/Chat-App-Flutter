import 'package:chatapp/screens/ChatListScreen.dart';
import 'package:chatapp/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAuth.instance.signOut();
  var isUserLoggedIn = FirebaseAuth.instance.currentUser != null;
  runApp(GetMaterialApp(
    home: isUserLoggedIn ? const ChatListScreen() : const LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}