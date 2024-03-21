import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_app/components/my_button.dart';
import 'package:offering_collection_app/helper/helper_function.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;

  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  //Text controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Login method
  void login() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // pop loading circle
      // if (context.mounted) {
        Navigator.pop(context);
      // }
    }

    // display any error
    on FirebaseException catch (e) {
      // pop loading circle
      Navigator.pop(context);

      displayMessageToUser(e.code, context);
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
                  height: 380,
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
                          "Login",
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
                              // obscureText: true,
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
                        height: 40,
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: Color(0xFF787B7F),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      MyButton(
                        text: "Login",
                        onTap: login,
                      ),

                      const SizedBox(
                        height: 19,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Color(0xFF787B7F),
                              fontSize: 10,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              " Register Here",
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
          ),
        ),
        ),
      ),
    );
  }
}
