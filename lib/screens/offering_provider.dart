import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_app/model/offering_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferingProvider with ChangeNotifier {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('Churches');
  int _counter = 0;
  int get counter => _counter;

  // List<OfferingModel> offering = [];
  late var offering;

  Future<List<OfferingModel>> getData() async {
    offering = _reference.get();
    notifyListeners();
    return offering;
  }

  void _setPrefsOffering() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('offering_items', _counter);
    notifyListeners();
  }

  void _getPrefsOffering() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt("offering_items") ?? 0;
  }

  void addCounter() {
    _counter++;
    _setPrefsOffering();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefsOffering();
    notifyListeners();
  }

  int getcounter() {
    _getPrefsOffering();
    return _counter;
  }
}