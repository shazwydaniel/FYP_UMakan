import 'package:flutter/material.dart';

class AdminSupportorg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Support Organisation'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Text(
          'Support Organisation Management Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
