// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  ProgressDialog({super.key, this.message});

  String? message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blue,
      child: Container(
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget> [
              const SizedBox(width: 6.0),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(width: 26),
              Text(message ?? 'carregando...',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}