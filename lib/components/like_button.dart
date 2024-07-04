import 'package:flutter/material.dart';

class LikedButton extends StatelessWidget {
  final bool isLiked;
  final Function()? onTap;

  const LikedButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border_rounded,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
