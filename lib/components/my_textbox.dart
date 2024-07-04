import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String username;
  final String bio;
  final Function()? onTap;
  const MyTextBox(
      {super.key,
      required this.bio,
      required this.username,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.secondaryContainer),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(username),
              IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.settings),
              )
            ],
          ),
          Text(
            bio,
          ),
        ],
      ),
    );
  }
}
