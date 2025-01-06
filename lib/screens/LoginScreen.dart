

import 'package:chatapp/screens/ChatListScreen.dart';
import 'package:chatapp/screens/SignupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/snackbarWidgets/CustomSnackbar.dart';
import '../widgets/textWidgets/CustomTextWidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn() async {
    try {

      var email = _emailController.text.trim();
      var password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        CustomSnackbar(
            text: "Every field is mandatory!",
            backgroundColor: Colors.redAccent);
        return;
      }
      if (!GetUtils.isEmail(email)) {
        CustomSnackbar(
            text: "Email is not a valid email!",
            backgroundColor: Colors.redAccent);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        _isLoading = false;
      });
      Get.off(const ChatListScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      CustomSnackbar(
          text: "Email or Password is incorrect!", backgroundColor: Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign In",
          style: headingStyle1(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.indigoAccent,)
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.password, color: Colors.indigoAccent,)
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? (){} : signIn,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 6
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(_isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white, // Set the color to white
                        strokeWidth: 3.0,
                      ),
                    ),
                    if(_isLoading)
                    SizedBox(width: 10,),
                    Text(
                      "Sign In",
                      style: smallText2(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Do not have an account? ", style: smallText1(),),
                InkWell(
                  child: Text("Sign Up", style: smallText1Bold(color: Colors.indigoAccent),),
                  onTap: (){
                    Get.off(const SignupScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
