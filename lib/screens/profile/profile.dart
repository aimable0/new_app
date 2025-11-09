import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_app/services/auth_service.dart';
import 'package:new_app/shared/bottom_bar.dart';
import 'package:new_app/shared/styled_button.dart';
import 'package:new_app/shared/styled_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final User user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Switch states
  bool emailUpdates = false;
  bool notificationReminders = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        emailUpdates = data['emailUpdates'] ?? false;
        notificationReminders = data['notificationReminders'] ?? false;
      });
    }
  }

  Future<void> _updatePreference(String key, bool value) async {
    setState(() {
      if (key == 'emailUpdates') emailUpdates = value;
      if (key == 'notificationReminders') notificationReminders = value;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .set({key: value}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    // Get initials for avatar
    String getInitials(String? name) {
      if (name == null || name.isEmpty) return '';
      final names = name.split(' ');
      String initials = names.map((n) => n[0]).take(2).join();
      return initials.toUpperCase();
    }

    final dateJoined = widget.user.metadata.creationTime != null
        ? "${widget.user.metadata.creationTime!.year}-${widget.user.metadata.creationTime!.month.toString().padLeft(2, '0')}-${widget.user.metadata.creationTime!.day.toString().padLeft(2, '0')}"
        : 'Unknown';

    // Helper for underlined row
    Widget buildRow(Widget child) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: child,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const StyledAppBarText('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[400],
              child: Text(
                getInitials(widget.user.displayName ?? widget.user.email),
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Username
            Text(
              widget.user.displayName ?? 'No Username',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Email row (underlined)
            buildRow(Row(
              children: [
                const Icon(Icons.email, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.user.email ?? 'No email',
                      style: const TextStyle(fontSize: 16)),
                ),
              ],
            )),
            const SizedBox(height: 20),

            // Date joined (underlined)
            buildRow(Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 10),
                Text('Joined on $dateJoined', style: const TextStyle(fontSize: 16)),
              ],
            )),
            const SizedBox(height: 20),

            // Email updates switch (underlined)
            buildRow(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Email Updates', style: TextStyle(fontSize: 16)),
                Switch(
                  value: emailUpdates,
                  onChanged: (val) => _updatePreference('emailUpdates', val),
                  activeColor: Colors.blue,
                ),
              ],
            )),

            // Notification reminders switch (underlined)
            buildRow(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Notification Reminders', style: TextStyle(fontSize: 16)),
                Switch(
                  value: notificationReminders,
                  onChanged: (val) => _updatePreference('notificationReminders', val),
                  activeColor: Colors.blue,
                ),
              ],
            )),

            const SizedBox(height: 30),

            // Log out button
            StyledButton(
              onPressed: () {
                AuthService.signOut();
              },
              child: const StyledButtonText('Log out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 3),
    );
  }
}
