import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_app/model/church_model.dart';
import 'package:offering_collection_app/screens/give_page.dart';
import 'package:offering_collection_app/screens/profile_screen.dart';
import 'package:offering_collection_app/screens/search_page.dart';

class ChurchDetailsPage extends StatefulWidget {
  const ChurchDetailsPage({super.key});

  @override
  State<ChurchDetailsPage> createState() => _ChurchDetailsPageState();
}

class _ChurchDetailsPageState extends State<ChurchDetailsPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference _reference = FirebaseFirestore.instance.collection('Churches');

  var userPic;

  String searchText = '';

  var imgUrl = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
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
                    MaterialPageRoute(builder: (context) => SearchPage()),
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
                  child: Row(
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
      body: FutureBuilder<QuerySnapshot>(
        future: _reference.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            List<Church> churches = documents
                .map((e) => Church(
                      id: e['id'],
                      logo: e['logo'],
                      name: e['name'],
                      email: e['email'],
                      contact: e['contact'],
                      location: e['location'],
                      login: e['login'],
                      // id: e['id'],
                    ))
                .toList();
            return _getBody(churches);
          } else {
            // Show Loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _getBody(List<Church> churches) {
    return churches.isEmpty
        ? const Center(
            child: Text(
              'No Churches Yet',
              textAlign: TextAlign.center,
            ),
          )
        : searchText.isEmpty
            ? ListView.builder(
                itemCount: churches.length,
                itemBuilder: (context, index) =>
                    getCard(churches, index, context))
            : ListView.builder(
                itemCount: churches.length,
                itemBuilder: (context, index) {
                  if (churches[index]
                      .name
                      .toLowerCase()
                      .startsWith(searchText.toLowerCase())) {
                    return getCard(churches, index, context);
                  }
                  return const SizedBox();
                },
              );
  }

  Card getCard(churches, int index, BuildContext context) {
    return Card(
      child: ListTile(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GivePage(
                  church: churches[index],
                ),
              ));
        }),
        leading: CircleAvatar(
          // radius: 70,
          backgroundImage: NetworkImage(churches[index].logo),
        ),
        title: Text(
          churches[index].name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        subtitle: Text('Email: ${churches[index].email}'),
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
