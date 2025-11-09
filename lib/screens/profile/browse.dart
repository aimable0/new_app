import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/shared/bottom_bar.dart';
import 'package:new_app/shared/styled_text.dart';
import 'package:new_app/theme.dart';

class Browse extends ConsumerStatefulWidget {
  const Browse({super.key});

  @override
  ConsumerState<Browse> createState() => _BrowseState();
}

class _BrowseState extends ConsumerState<Browse> {


  // logic for fetching books

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledAppBarText("Browse Listings"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text('No books for Now')),
        ),
      bottomNavigationBar: const BottomBar(currentIndex: 0),
    );
  }
}