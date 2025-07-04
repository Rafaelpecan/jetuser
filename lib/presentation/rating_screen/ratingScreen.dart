import 'package:flutter/material.dart';
import 'package:jetrideruser/presentation/botton_navigator/bottonNavigator.dart';

class Ratingscreen extends StatelessWidget {
  const Ratingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating'),
      ),
      bottomNavigationBar: CustomBottomNavigator(),
      body: const Text('Rating')
    );
  }
}