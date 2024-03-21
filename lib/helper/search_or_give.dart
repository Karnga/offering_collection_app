import 'package:flutter/material.dart';
import 'package:offering_collection_app/screens/login_page.dart';
import 'package:offering_collection_app/screens/register.dart';

class SearchOrGive extends StatefulWidget {
  const SearchOrGive({super.key});

  @override
  State<SearchOrGive> createState() => _SearchOrGiveState();
}

class _SearchOrGiveState extends State<SearchOrGive> {

  //initially, show login page
  bool showSearchPage = true;

  //toggle between login and register page
  void togglePages() {
    setState(() {
      showSearchPage = !showSearchPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showSearchPage) {
      return Login(onTap: togglePages);
    } else {
      return Register(onTap: togglePages);
    }

  }
}