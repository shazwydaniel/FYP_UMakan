import 'package:flutter/material.dart';

class AdminAuthority extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Authority'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          'Authority Management Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
