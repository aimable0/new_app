import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app/services/storage_service.dart';
import 'package:new_app/services/firestore_service.dart';
import 'package:new_app/models/book/book.dart';
import 'package:new_app/models/book/book_enums.dart';
import 'package:new_app/shared/bottom_bar.dart';
import 'package:new_app/shared/styled_button.dart';
import 'package:new_app/shared/styled_text.dart';
import 'package:new_app/theme.dart';

class PostBook extends StatefulWidget {
  const PostBook({super.key});

  @override
  State<PostBook> createState() => _PostBookState();
}

class _PostBookState extends State<PostBook> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _author = TextEditingController();
  final TextEditingController _swapFor = TextEditingController();

  // Image picker
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;

  Future<void> pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  // Error & condition
  String? _errorFeedback;
  BookCondition? selectedCondition;

  final List<BookCondition> conditions = [
    BookCondition.New,
    BookCondition.LikeNew,
    BookCondition.Good,
    BookCondition.Used,
  ];

  String _bookConditionToLabel(BookCondition condition) {
    switch (condition) {
      case BookCondition.New:
        return "New";
      case BookCondition.LikeNew:
        return "Like-New";
      case BookCondition.Good:
        return "Good";
      case BookCondition.Used:
        return "Used";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledAppBarText('Post Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Book Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter book title'
                    : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter book author'
                    : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _swapFor,
                decoration: const InputDecoration(
                  labelText: 'Swap For',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a desired swap'
                    : null,
              ),
              const SizedBox(height: 16.0),
              StyledBodyText('Condition:'),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 10,
                children: conditions.map((condition) {
                  return ChoiceChip(
                    label: Text(_bookConditionToLabel(condition)),
                    selected: selectedCondition == condition,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCondition = selected ? condition : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              // Image picker
              GestureDetector(
                onTap: pickImage,
                child: _imageFile == null
                    ? Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: const Center(
                          child: Text("Tap to select book image"),
                        ),
                      )
                    : Image.file(_imageFile!, height: 160, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16.0),

              // Error feedback
              if (_errorFeedback != null)
                Text(
                  _errorFeedback!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16.0),
              // Submit button
              StyledButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (selectedCondition == null) {
                    setState(() {
                      _errorFeedback = 'Please select a condition';
                    });
                    return;
                  }
                  if (_imageFile == null) {
                    setState(() {
                      _errorFeedback = 'Please pick a book image';
                    });
                    return;
                  }

                  setState(() {
                    _errorFeedback = null;
                    _loading = true;
                  });

                  try {
                    final user = FirebaseAuth.instance.currentUser!;
                    final userId = user.uid;

                    final imageUrl = await StorageService.uploadBookCover(
                      _imageFile!,
                      userId,
                    );

                    final book = Book(
                      id: "", // Firestore auto-generates
                      title: _title.text.trim(),
                      author: _author.text.trim(),
                      swapFor: _swapFor.text.trim(),
                      condition: selectedCondition!,
                      status: BookStatus.available,
                      coverImageUrl: imageUrl,
                      ownerId: userId,
                      ownerName: user.displayName,
                      postedAt: Timestamp.now(),
                    );

                    await FirestoreService.postBook(book);

                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    setState(() {
                      _errorFeedback = 'Failed to post. Try again.';
                    });
                    print('Error: $e');
                  } finally {
                    if (mounted) setState(() => _loading = false);
                  }
                },
                child: const StyledButtonText('Post book'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
