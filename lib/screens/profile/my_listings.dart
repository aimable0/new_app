import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/providers/user_books_provider.dart';
import 'package:new_app/screens/profile/book_card.dart';
import 'package:new_app/screens/profile/post_book.dart';
import 'package:new_app/shared/bottom_bar.dart';
import 'package:new_app/shared/styled_text.dart';
import 'package:new_app/theme.dart';

class MyListings extends ConsumerStatefulWidget {
  const MyListings({super.key});

  @override
  ConsumerState<MyListings> createState() => _MyListingsState();
}

class _MyListingsState extends ConsumerState<MyListings> {
  @override
  Widget build(BuildContext context) {
    final userBooksAsync = ref.watch(userBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const StyledAppBarText("My Listings"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, weight: 40, color: Colors.blue[500],), // the icon
            iconSize: 32,
            tooltip: 'Add a book', // optional tooltip
            onPressed: () {
              // Your functionality here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const PostBook()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // list of books -
            Expanded(
              child: userBooksAsync.when(
                data: (userBooks) {
                  if (userBooks.isEmpty) {
                    return const Center(child: Text('No books yet'));
                  }
                  return ListView.builder(
                    itemCount: userBooks.length,
                    itemBuilder: (context, index) {
                      return BookCard(userBooks[index]);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 0),
    );
  }
}
