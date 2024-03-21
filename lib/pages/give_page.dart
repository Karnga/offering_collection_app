import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:offering_collection_app/components/my_button.dart';
import 'package:offering_collection_app/helper/helper_function.dart';
import 'package:offering_collection_app/model/church_model.dart';
import 'package:offering_collection_app/pages/search_page.dart';
import 'package:offering_collection_app/pages/profile_screen.dart';

class GivePage extends StatefulWidget {
  final Church church;
  GivePage({super.key, required this.church});

  @override
  State<GivePage> createState() => _GivePageState();
}

class _GivePageState extends State<GivePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  
  final TextEditingController amountController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  var userPic;

  void clearText() {
    amountController.clear();
    numberController.clear();
  }

  // get current user email address
  String? email;
  final _auth = FirebaseAuth.instance;
  void getCurrentUserEmail() async {
    final user = _auth.currentUser!.email;
    email = user;
  }

  // add offering
  void addOffering() async {
    getCurrentUserEmail();
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try adding the offering
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      Navigator.pop(context);
      // if (context.mounted) Navigator.pop(context);

      // create a offering document and add to firestore
      FirebaseFirestore.instance.collection("Offerings").doc().set({
        'church_id': widget.church.id,
        'logo': widget.church.logo,
        'churchname': widget.church.name,
        'amount': amountController.text,
        'number': numberController.text,
        'paymentMethod': paymentValue,
        'offeringType': offeringValue,
        'email': email,
        'date': DateFormat('d MMMM y').format(DateTime.now()).toString(),
      });

      // pop loading circle
      // Navigator.pop(context);
      if (context.mounted) Navigator.pop(context);

      // _showToast(context);

      Fluttertoast.showToast(
          msg: "Thanks For Giving",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: Colors.white,
          fontSize: 16.0);

      clearText();
    } on FirebaseAuthException catch (e) {
      /// pop loading circle
      Navigator.pop(context);

      // display error message to user
      displayMessageToUser(e.code, context);
    }
  }

  // payment dropdown menu
  final paymentItem = ["MTN", "Airtel"];
  String? paymentValue;

  // offering dropdown menu
  final offeringItem = ["Regular Offering", "Tithe", "Pastor Appreciation"];
  String? offeringValue;

  DropdownMenuItem<String> buildMenuItem(String listItem) => DropdownMenuItem(
      value: listItem,
      child: Text(
        listItem,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ));

  var imgUrl = "";

  String name = "";

  // logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: _boxDecoration(),
          child: SafeArea(
              child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Find Churches",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(currentUser.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userData = snapshot.data!.data() as Map<String, dynamic>;
                          userPic = userData['profile_pic'];
                          return CircleAvatar(
                              // radius: 70,
                              backgroundImage: NetworkImage(userPic)
                              // userPic != null
                              // ? NetworkImage(userData['profile_pic'])
                              // : NetworkImage('https://firebasestorage.googleapis.com/v0/b/offering-app.appspot.com/o/users%2Fprofile-default.jpeg?alt=media&token=0a08e690-f66f-450f-bb06-f457216a9ad0')
                                );
                        }
                        return SizedBox();
                      },
                    ),
                  )
                ],
              ),
              // _topBar(),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1.4,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'example: my churchh of Christ',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
        ),
      ),
      body: SizedBox(
        child: Center(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide()
                  )
                ),
                child: ListTile(
                  leading:
                      // Text('Church'),
                      Image.network(widget.church.logo),
                  title: Text(
                    widget.church.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    // textScaleFactor: 1.5,
                  ),
                  subtitle: Text('Email: ${widget.church.email}'),
                  // trailing: SizedBox(
                  //   width: 60,
                  //   child: Row(
                  //     children: [],
                  //   ),
                  // ),
                  // selected: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 105),
              child: Container(
                margin: EdgeInsets.only(left: 10),
                // height: 475,
                width: 340,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFFF4F5F0),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 137),
                          child: Text(
                            "PAYMENT METHOD",
                            style: TextStyle(
                              color: Color(0xFF83878A),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),

                        // payment dropdown menu
                        Container(
                          height: 45,
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                // width: 4,
                              )),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text("Choose payment method"),
                              value: paymentValue,
                              isExpanded: true,
                              iconSize: 40,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              style: TextStyle(
                                color: Color(0xFF83878A),
                              ),
                              items: paymentItem.map(buildMenuItem).toList(),
                              onChanged: (value) =>
                                  setState(() => this.paymentValue = value),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        // offering dropdown menu
                        Container(
                          margin: EdgeInsets.only(right: 168),
                          child: Text(
                            "OFFERING TYPE",
                            style: TextStyle(
                              color: Color(0xFF83878A),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),

                        Container(
                          height: 45,
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(
                            //   color: Colors.white,
                            //   // width: 4,
                            // )
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text("Choose offering type"),
                              value: offeringValue,
                              isExpanded: true,
                              iconSize: 40,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              style: TextStyle(
                                color: Color(0xFF83878A),
                              ),
                              items: offeringItem.map(buildMenuItem).toList(),
                              onChanged: (value) =>
                                  setState(() => this.offeringValue = value),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          margin: EdgeInsets.only(right: 165),
                          child: Text(
                            "PHONE NUMBER",
                            style: TextStyle(
                              color: Color(0xFF83878A),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 11),
                          child: SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 50,
                                  color: Color(0xFFE6E7E2),
                                  child: Center(
                                    child: Text(
                                      "+250",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF787B7F)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 45,
                                  width: 267,
                                  child: CupertinoTextField(
                                    controller: numberController,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF787B7F),
                                      ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          margin: EdgeInsets.only(right: 234),
                          child: Text(
                            "AMOUNT",
                            style: TextStyle(
                              color: Color(0xFF83878A),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),

                        // const SizedBox(
                        //   height: 5,
                        // ),

                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  height: 44,
                                  width: 50,
                                  color: Color(0xFFE6E7E2),
                                  child: Center(
                                    child: Text(
                                      "RWF",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF787B7F)
                                        ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 45,
                                  width: 268,
                                  child: CupertinoTextField(
                                    controller: amountController,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF787B7F),
                                      ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        Container(
                          margin: EdgeInsets.only(right: 269),
                          child: Text(
                            "Min: 10",
                            style: TextStyle(
                              color: Color(0xFF83878A),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        MyButton(
                          text: "Give",
                          onTap: addOffering,
                        ),

                        const SizedBox(
                          height: 19,
                        ),

                        SizedBox(
                          width: 325,
                          child: RichText(
                              text: TextSpan(
                                  text: "What happens next?",
                                  style: TextStyle(
                                    color: Color(0xFF252A2D),
                                    fontSize: 18,
                                  ),
                                  children: const <TextSpan>[
                                TextSpan(
                                    text:
                                        " Confirm the deposit request on your phone to complete your deposit process.",
                                    style: TextStyle(
                                      color: Color(0xFF83878A),
                                    ))
                              ])),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      image: DecorationImage(
        image: AssetImage("assets/splash_screen.png"),
        fit: BoxFit.cover,
      ),
    );
  }
}
