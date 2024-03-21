import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:offering_collection_app/auth/auth.dart';
import 'package:offering_collection_app/components/textbox.dart';
import 'package:offering_collection_app/screens/navbar_page.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offering_collection_app/components/text_box.dart';
import 'package:offering_collection_app/helper/controller.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;

  //user collection
  final currentUser = FirebaseAuth.instance.currentUser!;

  // all users
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  ProfileController profileController = Get.put(ProfileController());

  var userPic;
  late File imageFile;
  var picUrl;

  Future<void> updatePic() async {
    // if(picUrl.trim().isNotEmpty) {
    // final userCollection = FirebaseFirestore.instance.collection("Users");
    await usersCollection.doc(currentUser.email).update({'profile_pic': picUrl});
    // final docRef = userCollection.doc(user.id);
    // }
  }

  // take photo
  void takePhoto(ImageSource source) async {
    XFile? pickedImage;
    final imagePicker = ImagePicker();

    // take image from camera or gallery
    try {
      pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 100);
      final String fileName = path.basename(pickedImage!.path);
      imageFile = File(pickedImage.path);

      // Uploading the selected image to firebase
      try {
        var snapshot = storage.ref(fileName).putFile(imageFile);

        var url = await snapshot.storage.ref(fileName).getDownloadURL();
        picUrl = url.toString();
        updatePic();

        profileController.setProfileImagePath(imageFile.path);

        // print(url.toString());

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  // buttom sheet area
  Widget buttomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            'Choose Profile Photo',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera"),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.image),
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  // edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edti $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.grey)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // cancel button
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          // save button
          TextButton(
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          )
        ],
      ),
    );

    // update in firestore
    if (newValue.trim().isNotEmpty) {
      // only update if there is something in the textfield
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  // logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Center(
          child: Stack(
            children: [

              // Profile banner
              Container(
                height: 150,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/splash_screen.png'),
                    fit: BoxFit.cover,
                  ),
                  // color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
              ),

              // back arrow icon
              Positioned(
                  top: 37,
                  left: MediaQuery.of(context).size.width * 0.5 - 165,
                  child: InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewNav()),
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ),

              // profile title
              Positioned(
                  top: 30,
                  left: MediaQuery.of(context).size.width * 0.5 - 35,
                  child: const Text(
                    'PROFILE',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),

              // profile email
              Positioned(
                top: 200,
                left: MediaQuery.of(context).size.width * 0.5 - 180,
                child: Text(
                  'Details',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),

              // Profile image
              Positioned(
                top: 70,
                left: MediaQuery.of(context).size.width * 0.5 - 65,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUser.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      userPic = userData['profile_pic'];
                      return CircleAvatar(
                          radius: 70, backgroundImage: NetworkImage(userPic)
                          // userPic != null
                          // ? NetworkImage(userData['profile_pic'])
                          // : NetworkImage('https://firebasestorage.googleapis.com/v0/b/offering-app.appspot.com/o/users%2Fprofile-default.jpeg?alt=media&token=0a08e690-f66f-450f-bb06-f457216a9ad0')
                          );
                    }
                    return SizedBox();
                  },
                ),
              ),

              // Edit image icon
              Positioned(
                top: 180,
                left: MediaQuery.of(context).size.width * 0.5 + 35,
                child: InkWell(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.blue,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => buttomSheet()),
                    );
                  },
                ),
              ),

              // profile details
              Padding(
                padding: const EdgeInsets.only(top: 230),
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUser.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // get userr data
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;

                        return Container(
                          // height: 500,
                          decoration:
                              BoxDecoration(border: Border(top: BorderSide())),
                          child: ListView(
                            children: [
                              // // const SizedBox(height: 10,),

                              // // user details
                              // const Padding(
                              //   padding: EdgeInsets.only(left: 25.0),
                              //   child: Text(
                              //     'My Details',
                              //     style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: 17,
                              //     ),
                              //   ),
                              // ),

                              MyTextBox(
                              text: userData['names'],
                              sectionname: 'Names',
                              onPressed: () => editField('names'),
                              ),

                              EmailTextBox(
                              text: userData['email'], 
                              sectionname: 'Email', 
                              ),

                              // user contact
                              MyTextBox(
                              text: userData['contact'],
                              sectionname: 'Contact',
                              onPressed: () => editField('contact'),
                              ),

                              // user residance
                              MyTextBox(
                              text: userData['address'],
                              sectionname: 'Address',
                              onPressed: () => editField('address'),
                              ),

                              // user date created
                              MyTextBox(
                              text: userData['date_created'],
                              sectionname: 'Date Created',
                              onPressed: () => editField('username'),
                              ),

                              // user fav Bible verse
                              MyTextBox(
                              text: userData['fav_bible_verse'],
                              sectionname: 'Favorite Bible Verse',
                              onPressed: () => editField('username'),
                              ),

                              TextButton.icon(
                              onPressed: () {
                                logout();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AuthPage()));
                              },
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              ),
                              ),
                            ],
                          ),

                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error${snapshot.error}'),
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              )

            ],
          ),
        ),
      ),
    );
  }
}
