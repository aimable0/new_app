import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_app/screens/profile/browse.dart';
import 'package:new_app/screens/profile/chat.dart';
import 'package:new_app/screens/profile/my_listings.dart';
import 'package:new_app/screens/profile/profile.dart';
import 'package:new_app/screens/profile/settings.dart';
import 'package:new_app/theme.dart';

class BottomBar extends StatelessWidget {
  /// currentIndex indicates which page is active
  final int currentIndex;

  const BottomBar({super.key, this.currentIndex = 0});

  void _navigateTo(BuildContext context, int index) {
    if (index == currentIndex) return; // already on this page

    Widget page;
    switch (index) {
      case 0:
        page = const Browse();
        break;
      case 1:
        page = const MyListings();
        break;
      case 2:
        page = const Chat();
        break;
      case 3:
        page =  ProfileScreen(user: FirebaseAuth.instance.currentUser!);
        break;
      default:
        page = const Browse();
    }

    // Replace current page
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.feed, 'label': 'Browse'},
      {'icon': Icons.book, 'label': 'My Listings'},
      {'icon': Icons.chat_bubble, 'label': 'Chats'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    return BottomAppBar(
      padding: EdgeInsets.all(0),
      height: 80,
      color: AppColors.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(items.length, (i) {
          final color = (i == currentIndex) ? Colors.blue[500] : const Color.fromARGB(255, 245, 245, 245);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _navigateTo(context, i),
                icon: Icon(
                  items[i]['icon'] as IconData,
                  color: color,
                  size: 25,
                ),
              ),
              Text(
                items[i]['label'] as String,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
