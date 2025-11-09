import 'package:flutter/material.dart';
import 'package:new_app/models/book/book.dart';
import 'package:new_app/shared/styled_text.dart';
import 'package:new_app/theme.dart';

class BookCard extends StatelessWidget {
  const BookCard(this.book, {super.key});

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
                          height: 120,
                          width: 80,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 120,
                          width: 80,
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
                      const SizedBox(height: 7),
                      StyledBookAuthorText(book.author),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: StyledBookConditionText(book.condition.name),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Positioned edit icon at bottom right
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.edit, color: AppColors.primaryColor),
                onPressed: () {
                  // Your edit functionality here
                  print('Edit ${book.title}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
