import 'package:cloud_firestore/cloud_firestore.dart';

class OfferingModel {
  final String? id;
  final String? logo;
  final String? churchname;
  final String? email;
  final String? offeringType;
  final String? amount;
  final String? number;
  final String? paymentMethod;
  final String? date;

  OfferingModel({
    this.email,
    this.logo,
    this.churchname,
    this.paymentMethod, 
    this.offeringType, 
    this.amount,
    this.number, 
    this.id,
    this.date,
    });

  factory OfferingModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return OfferingModel(
      id: snapshot['id'],
      logo: snapshot['logo'],
      churchname: snapshot['churchname'],
      email: snapshot['email'],
      offeringType: snapshot['offeringType'],
      amount: snapshot['amount'],
      number: snapshot['number'],
      paymentMethod: snapshot['paymentMethod'],
      date: snapshot['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "church_name": churchname,
        "email": email,
        "offeringType": offeringType,
        "amount": amount,
        "number": number,
        "paymentMethod": paymentMethod,
        "date": date,
      };
}
