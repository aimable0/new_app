import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_app/shared/bottom_bar.dart';
// (Keep all your other imports)

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Please sign in to view chats')),
      );
    }

    return Scaffold(
      // AppBar will now use your main theme
      appBar: AppBar(
        title: const Text('Chat'),
        // No hardcoded color
      ),
      // Scaffold background will use your main theme
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        // We now query for all swaps where the current user
        // is one of the participants.
        stream: FirebaseFirestore.instance
            .collection('swaps')
            .where('participants', arrayContains: user.uid)
            .orderBy('createdAt', descending: true) // Optional: sort by new
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary, // Use theme color
            ));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey.shade400), // Lighter grey
                  SizedBox(height: 16),
                  Text(
                    'No chats yet',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600), // Darker grey
                  ),
                  Text(
                    'Request a swap to start a chat!', // Updated text
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          final seenSwapIds = <String>{};
          final uniqueSwaps = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

          for (final doc in snapshot.data!.docs) {
            if (seenSwapIds.add(doc.id)) uniqueSwaps.add(doc);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: uniqueSwaps.length,
            itemBuilder: (context, i) {
              final data = uniqueSwaps[i].data();
              final swapId = uniqueSwaps[i].id;

              final otherId = data['senderId'] == user.uid
                  ? data['receiverId']
                  : data['senderId'];

              final swapStatus = data['status'] ?? 'pending';

              return FutureBuilder<_ChatPreviewData>(
                future: _getChatPreview(otherId, swapId, user.uid),
                builder: (context, previewSnap) {
                  if (!previewSnap.hasData) return const _ChatTileSkeleton();

                  final preview = previewSnap.data!;

                  return Card(
                    // This color should match your "My Listings" cards
                    // e.g., Color(0xFFF0F4FF) or from theme
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withOpacity(0.5),
                    elevation: 0, // No shadow, like your new UI
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        // Use theme's primary color (blue)
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: preview.photoUrl != null
                            ? NetworkImage(preview.photoUrl!)
                            : null,
                        child: preview.photoUrl == null
                            ? Text(
                                preview.name.isNotEmpty
                                    ? preview.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  // Use theme's "onPrimary" color (white)
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        preview.name,
                        style: TextStyle(
                          // Use theme's "onSurface" color (black/dark)
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        preview.lastMessage,
                        // Use theme's secondary text color
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Show the swap status
                          Text(
                            swapStatus.toString().toUpperCase(),
                            style: TextStyle(
                              color: swapStatus == 'pending'
                                  ? Colors.orangeAccent
                                  : swapStatus == 'accepted'
                                      ? Colors.greenAccent
                                      : Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (preview.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red, // Unread count is still red
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${preview.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            preview.timeAgo,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 11),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatRoomScreen(swapId: swapId),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar:
          BottomBar(currentIndex: 2), // This path might be wrong
    );
  }

  Future<_ChatPreviewData> _getChatPreview(
    String uid,
    String swapId,
    String currentUserId,
  ) async {
    // ...
    // This function logic is correct and does not need theme changes.
    // ...
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      String name = 'User';
      String? photoUrl;

      if (userDoc.exists) {
        final data = userDoc.data()!;
        name = (data['displayName']?.toString().trim() ?? 'User');
        photoUrl = data['photoURL']?.toString();
        if (name.isEmpty) name = 'User';
      } else {
        final email = '$uid@example.com';
        name = email.split('@').first;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'displayName': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      final messagesSnap = await FirebaseFirestore.instance
          .collection('swaps')
          .doc(swapId)
          .collection('messages')
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      String lastMessage = 'No messages yet';
      Timestamp? lastTime;

      if (messagesSnap.docs.isNotEmpty) {
        final msgData = messagesSnap.docs.first.data();
        lastMessage = msgData['text'] ?? 'Media';
        lastTime = msgData['time'] as Timestamp?;
      }

      int unreadCount = 0;
      if (lastTime != null) {
        final unreadSnap = await FirebaseFirestore.instance
            .collection('swaps')
            .doc(swapId)
            .collection('messages')
            .where('sender', isNotEqualTo: currentUserId)
            .get();
        unreadCount = unreadSnap.docs.length;
      }

      String timeAgo = 'Just now';
      if (lastTime != null) {
        final diff = DateTime.now().difference(lastTime.toDate());
        if (diff.inMinutes < 1) {
          timeAgo = 'now';
        } else if (diff.inHours < 1) {
          timeAgo = '${diff.inMinutes}m ago';
        } else if (diff.inDays < 1) {
          timeAgo = '${diff.inHours}h ago';
        } else {
          timeAgo = '${diff.inDays}d ago';
        }
      }

      return _ChatPreviewData(
        name: name,
        photoUrl: photoUrl,
        lastMessage: lastMessage,
        unreadCount: unreadCount,
        timeAgo: timeAgo,
      );
    } catch (e) {
      return _ChatPreviewData(
        name: 'User',
        lastMessage: 'Error',
        unreadCount: 0,
        timeAgo: '',
      );
    }
  }
}

class _ChatPreviewData {
  final String name;
  final String? photoUrl;
  final String lastMessage;
  final int unreadCount;
  final String timeAgo;

  _ChatPreviewData({
    required this.name,
    this.photoUrl,
    required this.lastMessage,
    required this.unreadCount,
    required this.timeAgo,
  });
}

class _ChatTileSkeleton extends StatelessWidget {
  const _ChatTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      // Use theme color
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        // Use theme color
        leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary),
        title: Container(
          height: 10,
          color: Colors.grey.shade300,
          margin: const EdgeInsets.only(right: 80),
        ),
        subtitle: Container(
          height: 10,
          color: Colors.grey.shade200,
          margin: const EdgeInsets.only(right: 30),
        ),
      ),
    );
  }
}

//
// --- *** CHAT ROOM SCREEN THEME UPDATE *** ---
//
class ChatRoomScreen extends StatefulWidget {
  final String swapId;
  const ChatRoomScreen({required this.swapId, super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  late final User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('swaps')
        .doc(widget.swapId)
        .collection('messages')
        .add({
      'text': text,
      'sender': _currentUser.uid,
      'time': FieldValue.serverTimestamp(),
    });

    _msgCtrl.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final Color surfaceVariantColor =
        Theme.of(context).colorScheme.surfaceVariant;
    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final Color onSurfaceVariantColor =
        Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      // Use theme colors
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: primaryColor, // Blue
        foregroundColor: onPrimaryColor, // White
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('swaps')
                  .doc(widget.swapId)
                  .collection('messages')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: primaryColor));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No messages yet. Say hi!'));
                }

                final messages = snapshot.data!.docs;
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollCtrl,
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final data = messages[i].data();
                    final isMe = data['sender'] == _currentUser.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          // Use theme colors for bubbles
                          color: isMe ? primaryColor : surfaceVariantColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data['text'] ?? '',
                          style: TextStyle(
                            // Use theme colors for text
                            color: isMe ? onPrimaryColor : onSurfaceColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // --- Input Bar ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                .copyWith(bottom: MediaQuery.of(context).padding.bottom + 8),
            // Use theme surface color (white)
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    // Use theme color
                    style: TextStyle(color: onSurfaceColor),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      // Use theme color
                      hintStyle: TextStyle(color: onSurfaceVariantColor),
                      filled: true,
                      // Use theme color (light grey)
                      fillColor: surfaceVariantColor.withOpacity(0.7),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  // Use theme color (blue)
                  backgroundColor: primaryColor,
                  child: IconButton(
                    // Use theme color (white)
                    icon: Icon(Icons.send, color: onPrimaryColor),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}