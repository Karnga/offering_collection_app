import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offering_collection_app/components/my_button.dart';
import 'package:offering_collection_app/helper/controller.dart';
import 'package:offering_collection_app/helper/helper_function.dart';

class Register extends StatefulWidget {
  final void Function()? onTap;

  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ProfileController profileController = Get.put(ProfileController());

  // register user
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try creating the user
    try {
      //create the user
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, 
              password: passwordController.text
              );

      // create a user document and add to firestore
      FirebaseFirestore.instance
      .collection("Users")
      .doc(userCredential.user!.email)
      .set({
        'username' : usernameController.text, // initial username
        'names' : '',
        'email' : userCredential.user!.email,
        'contact' : '',
        'address' : '',
        'date_created' : DateTime.now().toString(),
        'device_token': '',
        'fav_bible_verse' : '',
        'profile_pic' : 'https://firebasestorage.googleapis.com/v0/b/offering-app.appspot.com/o/users%2Fprofile-default.jpeg?alt=media&token=0a08e690-f66f-450f-bb06-f457216a9ad0'
    });

      // pop loading circle
      Navigator.pop(context);
      // if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      /// pop loading circle
      Navigator.pop(context);

      // display error message to user
      displayMessageToUser(e.code, context);
    }
  }

  //create a user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/splash_screen.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  height: 415,
                  width: 330,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 45,
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Color(0xFF83878A),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 310,
                            height: 60,
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFEEF5FB),
                                  // iconColor: Colors.blue,
                                  labelText: "Username",
                                  labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon: const Icon(
                                    Icons.account_circle_rounded,
                                    size: 30,
                                    color: Color(0xFF83878A),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 2)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 310,
                            height: 60,
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFEEF5FB),
                                  // iconColor: Colors.blue,
                                  labelText: "Email",
                                  labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    size: 30,
                                    color: Color(0xFF83878A),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 2)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 310,
                            height: 60,
                            child: TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFEEF5FB),
                                  // iconColor: Colors.blue,
                                  labelText: "Password",
                                  labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    size: 30,
                                    color: Color(0xFF83878A),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 2)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 8,
                      ),

                      // Register button
                      MyButton(
                        text: "REGISTER",
                        onTap: registerUser,
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Color(0xFF787B7F),
                              fontSize: 10,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              " Login Here",
                              style: TextStyle(
                                color: Color(0xFF787B7F),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ],
          )),
        ),
      ),
    );
  }
}
