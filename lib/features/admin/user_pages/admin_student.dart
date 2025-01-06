import 'package:flutter/material.dart';

class AdminStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Students'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'Students Management Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
