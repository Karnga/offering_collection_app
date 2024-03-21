import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionname;
  final void Function()? onPressed;

  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionname,
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
          left: 15,
          bottom: 15,
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // section name
              Text(
                sectionname,
                style: const TextStyle(color: Colors.grey),
                ),

              // edit button
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.edit),
              )
            ],
          ),

          // text
          Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}