import 'package:flutter/material.dart';
import 'package:new_app/services/auth_service.dart';
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

  String? _errorFeedback;
  String? selectedCondition; // <-- selected condition
  final List<String> conditions = ['Used', 'New', 'Like-New', 'Good'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledAppBarText('Post Book')),
      body: Padding(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book author';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _swapFor,
                decoration: InputDecoration(
                  labelText: 'Swap For',
                  border: OutlineInputBorder(),
                  focusColor: Colors.blue[500],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a desired swap';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              StyledBodyText('Condition: '),
              const SizedBox(height: 8.0),

              // --- Condition selector ---
              Wrap(
                spacing: 10,
                children: conditions.map((condition) {
                  return ChoiceChip(
                    label: Text(condition),
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

              // error feedback
              if (_errorFeedback != null)
                Text(
                  _errorFeedback!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16.0),

              // submit button
              StyledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (selectedCondition == null) {
                      setState(() {
                        _errorFeedback = 'Please select a condition';
                      });
                      return;
                    }
                    setState(() {
                      _errorFeedback = null;
                    });
                    // save book here
                    // you can use `selectedCondition` as the book condition
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
