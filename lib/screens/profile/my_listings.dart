import 'package:flutter/material.dart';
import 'package:new_app/shared/bottom_bar.dart';
import 'package:new_app/shared/styled_text.dart';

class MyListings extends StatefulWidget {
  const MyListings({super.key});

  @override
  State<MyListings> createState() => _MyListingsState();
}

class _MyListingsState extends State<MyListings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledAppBarText("My Listings"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text('Screen under construction')),
        ),
      bottomNavigationBar: const BottomBar(currentIndex: 0),
    );
  }
}