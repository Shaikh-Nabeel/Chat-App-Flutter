import 'package:chatapp/controllers/FirebaseController.dart';
import 'package:chatapp/screens/ChatListScreen.dart';
import 'package:chatapp/screens/LoginScreen.dart';
import 'package:chatapp/widgets/snackbarWidgets/CustomSnackbar.dart';
import 'package:chatapp/widgets/textWidgets/CustomTextWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> signUp() async {
    try {
      var email = _emailController.text.trim();
      var password = _passwordController.text.trim();
      var confirmPassword = _confirmPasswordController.text.trim();

      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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
      if (password.length < 8) {
        CustomSnackbar(
            text: "Password must be 8 character long!",
            backgroundColor: Colors.redAccent);
        return;
      }
      if (!(password == confirmPassword)) {
        CustomSnackbar(
            text: "Password does not match!",
            backgroundColor: Colors.redAccent);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      var user = _auth.currentUser!;
      await insertUser(user.email!, user.displayName , user.photoURL);
      setState(() {
        _isLoading = false;
      });
      Get.off(const ChatListScreen(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      CustomSnackbar(
          text: "Something went wrong! Try Again.",
          backgroundColor: Colors.blueAccent);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: headingStyle1(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.indigoAccent,
                  )),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(
                    Icons.password,
                    color: Colors.indigoAccent,
                  )),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(
                    Icons.password,
                    color: Colors.indigoAccent,
                  )),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? () {} : signUp,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white, // Set the color to white
                          strokeWidth: 3.0,
                        ),
                      ),
                    if (_isLoading)
                      const SizedBox(
                        width: 10,
                      ),
                    Text(
                      "Sign Up",
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
                Text(
                  "Already have an account? ",
                  style: smallText1(),
                ),
                InkWell(
                  child: Text(
                    "Sign In",
                    style: smallText1Bold(color: Colors.indigoAccent),
                  ),
                  onTap: () {
                    Get.off(const LoginScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300));
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
