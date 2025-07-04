import 'package:flutter/material.dart';
import 'package:jetrideruser/presentation/botton_navigator/bottonNavigator.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      bottomNavigationBar: CustomBottomNavigator(),
      body: const Text('Profile')
    );
  }
}