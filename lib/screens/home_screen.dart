import 'package:app1/utlis/colors.dart';
import 'package:app1/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextWidget(
          text: 'HOME',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Icon(
          Icons.home,
          size: 75,
        ),
      ),
    );
  }
}
