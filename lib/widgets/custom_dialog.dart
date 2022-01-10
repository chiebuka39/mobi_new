import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(color: Colors.redAccent, height: 300,),
    );
  }
}