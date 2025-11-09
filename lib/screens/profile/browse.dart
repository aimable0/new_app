import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/providers/all_books_provider.dart';
import 'package:new_app/screens/profile/feed_post_card.dart';
import 'package:new_app/shared/bottom_bar.dart';
import 'package:new_app/shared/styled_text.dart';

class Browse extends ConsumerStatefulWidget {
  const Browse({super.key});

  @override
  ConsumerState<Browse> createState() => _BrowseState();
}

class _BrowseState extends ConsumerState<Browse> {



  @override
  // logic for fetching books
  Widget build(BuildContext context) {

    final allBooksAsync = ref.watch(allBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const StyledAppBarText("Browse Listings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // list books
            Expanded(
              child: allBooksAsync.when(
                data: (userBooks) {
                  if (userBooks.isEmpty) {
                    return const Center(child: Text('No books Posted yet'));
                  }
                  return ListView.builder(
                    itemCount: userBooks.length,
                    itemBuilder: (context, index) {
                      return FeedPostCard(userBooks[index]);
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