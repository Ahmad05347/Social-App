import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final String users;
  final String text;
  final String time;
  const Comments(
      {super.key, required this.text, required this.time, required this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          Row(
            children: [
              Text(
                users,
                style: TextStyle(
                  color: Colors.grey[200],
                ),
              ),
              Text(
                " . ",
                style: TextStyle(
                  color: Colors.grey[200],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[200],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
