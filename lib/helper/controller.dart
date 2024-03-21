import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileController extends GetxController {

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  var isProfilePicPathSet = false.obs;
  var profilePicPath = "".obs;

  void setProfileImagePath(String path) {
    profilePicPath.value = path;
    isProfilePicPathSet.value = true;
  }
}


void uploadImage(BuildContext context) {
  // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/profileImage'+SessionController.userId.toString());
}






// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/foundation.dart';



// pickImage(ImageSource source) async {
//   final ImagePicker imagePicker = ImagePicker();
//   XFile? file = await imagePicker.pickImage(source: source);
//   // if (file != null){
//   //   return await file.readAsBytes();
//   // }
//   // print("No Image Slected!");
  
// }




// class controller with ChangeNotifier {

//   final picker = ImagePicker();

//   File? _image;

//   File? get image => _image;

//   Future pickGallaryImage(BuildContext context) async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

//     if(pickedFile != null) {
//       _image = File(pickedFile.path);
//     }
//   }

//   Future pickCameraImage(BuildContext context) async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

//     if(pickedFile != null) {
//       _image = File(pickedFile.path);
//     }
//   }

//   void pickImage(context) {
//     showDialog(
//       context: context, 
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SizedBox(
//             height: 120,
//             child: Column(
//               children: [
//                 ListTile(
//                   onTap: () {
//                     pickCameraImage(context);
//                   },
//                   leading: const Icon(Icons.camera, color: Colors.grey,),
//                   title: const Text("Camera")
//                 ),
//                 ListTile(
//                   onTap: () {
//                     pickGallaryImage;
//                   },
//                   leading: const Icon(Icons.image, color: Colors.grey,),
//                   title: const Text("Gallery")
//                 )
//               ],
//             ),
//           ),
//         );
//       }
//     );
//   }
// }