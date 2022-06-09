import 'package:flutter/material.dart';

class UploadImageBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Upload Image via..',
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ],
    );
  }
}
