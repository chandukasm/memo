import 'package:flutter/material.dart';

class Heart extends StatelessWidget {
  final bool isLiked;
  final Function handleTap;
  Heart({this.handleTap, this.isLiked});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
      icon: Icon(isLiked == true ? Icons.favorite : Icons.favorite_border,
          color: isLiked == true ? Colors.redAccent : Colors.redAccent),
      onPressed: handleTap,
    );
  }
}
