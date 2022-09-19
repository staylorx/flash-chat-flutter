// Flutter imports:
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:flash_chat/utilities/constants.dart';
import 'package:flash_chat/utilities/log_printer.dart';

final logger = Logger(printer: MyLogfmtPrinter('chat_screen'));
final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String id = '/chat';

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // messagesStream();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
        logger.d('loggedInUser = $loggedInUser');
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  //saving since this uses docChanges and not doc
  // void messagesStream() async {
  //   await for (var snapshot
  //       in _firestore.collection(kFirestoreCollectionName).snapshots()) {
  //     logger.d('*** snapshot received ***');
  //     for (var docChange in snapshot.docChanges) {
  //       logger.d(docChange.doc.data().toString());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                final navigator = Navigator.of(context);

                await _auth.signOut();
                logger.i('Signed out');

                // ignore: use_build_context_synchronously
                navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      messageTextController.clear();
                      if (messageText != '') {
                        try {
                          await _firestore
                              .collection(kFirestoreCollectionName)
                              .add({
                            'text': messageText,
                            'sender': loggedInUser.email,
                          });
                        } catch (e) {
                          logger.e(e.toString());
                        }
                      } else {
                        logger.w('messageText is empty... skipping');
                      }
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection(kFirestoreCollectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          );
        } else {
          logger.d('*** snapshot has data ***');
          List<MessageBubble> messageBubbles = [];
          final messages = snapshot.data!.docs.reversed;

          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');

            final currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
              messageSender: messageSender,
              messageText: messageText,
              isMe: (currentUser == messageSender),
            );

            messageBubbles.add(messageBubble);
          } //end !snapshot.hasData

          return Expanded(
            child: ListView(
              //this doesn't _quite_ work right. TBD
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        } //end builder
      },
    );
  }
}
