import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authority/screens/authority_bottom_nav_bar.dart';

class AuthorityHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authority Dashboard'),
      ),
      body: Center(
        child: Text('Welcome, Authority!'),
      ),
      bottomNavigationBar: AuthorityBottomNavBar(),
    );
  }
}