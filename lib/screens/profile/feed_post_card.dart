import 'package:flutter/material.dart';
import 'package:new_app/models/book/book.dart';
import 'package:new_app/shared/styled_text.dart';
import 'package:new_app/theme.dart';

class FeedPostCard extends StatelessWidget {
  const FeedPostCard(this.book, {super.key});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
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
