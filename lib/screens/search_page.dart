import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_app/model/church_model.dart';
import 'package:offering_collection_app/screens/give_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Churches');

  var imgUrl = "";
  String name = "";

  // @override
  // void initState() {
  //   super.initState();
  //   addData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          autofocus: true,
          onChanged: (val) {
            setState(() {
              name = val;
            });
          },
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
            return churches.isEmpty
                ? const Center(
                    child: Text(
                      'No Churches Yet',
                      textAlign: TextAlign.center,
                    ),
                  )
                : name.isEmpty
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
                              .startsWith(name.toLowerCase())) {
                            return getCard(churches, index, context);
                          }
                          return const SizedBox();
                        },
                      );
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
        // trailing: SizedBox(
        //   width: 60,
        //   child: Row(
        //     children: [],
        //   ),
        // ),
      ),
    );
  }
}
