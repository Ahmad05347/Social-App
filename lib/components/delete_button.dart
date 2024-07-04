import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function()? onTap;
  const DeleteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Icon(Icons.cancel),
    );
  }
}
