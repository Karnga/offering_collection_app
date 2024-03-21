
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_app/model/offering_model.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  // final CollectionReference _reference =
  //     FirebaseFirestore.instance.collection('Offerings').where("field", isEqualTo: currentUser.email).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Records Page"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
              .collection('Offerings')
              .where("email", isEqualTo: currentUser.email)
              .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            List<OfferingModel> churches = documents
                .map((e) => OfferingModel(
                      logo: e['logo'],
                      churchname: e['churchname'],
                      offeringType: e['offeringType'],
                      paymentMethod: e['paymentMethod'],
                      amount: e['amount'],
                      date: e['date'],
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

  Widget _getBody(List<OfferingModel> offerings) {
    return offerings.isEmpty
        ? const Center(
            child: Text(
              'No offerings Yet',
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
                itemCount: offerings.length,
                itemBuilder: (context, index) =>
                    getCard(offerings, index, context));
  }

  Card getCard(offerings, int index, BuildContext context) {
    return Card(
      child: ListTile(
        onTap: (() {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => GivePage(
          //         church: offerings[index],
          //       ),
          //     ));
        }),
        leading: 
        // Text(
        //   offerings[index].paymentMethod,
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 13,
        //     color: Colors.black,
        //   ),
        // ),
        CircleAvatar(
          // radius: 70,
          backgroundImage: NetworkImage(offerings[index].logo),
        ),
        title: Text(
          offerings[index].churchname,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          'Payment method: ${offerings[index].paymentMethod} \nAmount: RWF ${offerings[index].amount} \nDate: ${offerings[index].date}',
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Colors.black,
          ),
        ),
        trailing: Icon(Icons.check, color: Colors.green, size: 25,),
      ),
    );
  }
}