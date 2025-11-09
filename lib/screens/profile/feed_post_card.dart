import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/models/book/book.dart';
import 'package:new_app/screens/chat/chat_screen.dart';
import 'package:new_app/screens/profile/swap_service.dart';
import 'package:new_app/shared/styled_text.dart';
import 'package:new_app/theme.dart';

// 1. Change from StatelessWidget to ConsumerWidget
class FeedPostCard extends ConsumerWidget {
  const FeedPostCard(this.book, {super.key});

  final Book book;

  // 2. The main swap logic
  void _startSwap(BuildContext context, WidgetRef ref) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to swap!')),
        );
        return;
      }

      // Show a loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // 3. Call the service
      final swapService = ref.read(swapServiceProvider);
      final newSwapId = await swapService.initiateSwap(
        book: book,
        sender: currentUser,
      );

      // 4. Close the dialog and navigate to the new chat room
      Navigator.of(context).pop(); // Close loading dialog
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatRoomScreen(swapId: newSwapId),
        ),
      );
    } catch (e) {
      // Handle errors
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error starting swap: $e')));
    }
  }

  @override
  // 3. Add 'ref' to the build method
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. Get the current user to see if we should show the swap button
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final bool isMyBook = book.ownerId == currentUserId;

    return Card(
      // Your existing Card theme
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed width image
                Hero(
                  tag: book.id,
                  child: book.coverImageUrl != null
                      ? Image.network(
                          book.coverImageUrl!,
                          height: 160,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 160,
                          width: 100,
                          color: Colors.grey[300],
                          child: const Center(child: Text('No image')),
                        ),
                ),
                const SizedBox(width: 16),
                // Book details take remaining space
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledBookHeadingText(book.title),
                      const SizedBox(height: 4),
                      StyledBookAuthorText(book.author),
                      const SizedBox(height: 8),
                      StyledBookConditionSecondaryText(book.condition.name),
                      StyledBodyText(book.postedAt.toString()),

                      // --- 5. ADD THE SWAP BUTTON ---
                      if (!isMyBook) ...[
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => _startSwap(context, ref),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryAccent, // Use your theme
                            foregroundColor:
                                AppColors.primaryColor, // Use your theme
                          ),
                          child: const Text('Request Swap'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
