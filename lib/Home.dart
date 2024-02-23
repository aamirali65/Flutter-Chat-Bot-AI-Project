import 'dart:convert';

import 'package:aamir_ai/services/connection.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // all variables
  ChatUser myself = ChatUser(id: '1',firstName: 'Me');
  ChatUser bot = ChatUser(id: '2',firstName: 'Talkio');
  List<ChatMessage> allMessage = [];
  List<ChatUser> typing =[];
  final apiUrl = Uri.encodeFull('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBWayYsem2bcWFLgr8nC6vPusoqtWRB_dc');
  final apiHeader = {
    'Content-Type': 'application/json'
  };


  // Method to show AlertDialog
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // get data function
  // Modified getData function
  getData(ChatMessage m) async {
    typing.add(bot);
    allMessage.insert(0, m);
    setState(() {});

    final apiData = {"contents":[{"parts":[{"text":m.text}]}]};

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: apiHeader, body: jsonEncode(apiData));

      if (response.statusCode == 200) {
        var apiResult = jsonDecode(response.body);
        print(apiResult['candidates'][0]['content']['parts'][0]['text']);
        ChatMessage m1 = ChatMessage(
          user: bot,
          text: apiResult['candidates'][0]['content']['parts'][0]['text'],
          createdAt: DateTime.now(),
        );
        allMessage.insert(0, m1);
        setState(() {});
      } else {
        print('Error occurred');
        _showErrorDialog('Error occurred while fetching data.');
      }
    } catch (e) {
      print('Exception occurred: $e');
      _showErrorDialog('Exception occurred: $e');
    }

    typing.remove(bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030C1A),
      appBar: AppBar(
        backgroundColor: const Color(0xff030C1A),
        scrolledUnderElevation: 0,
        centerTitle: true,
        elevation: 0,
        title: const Text('Talkio AI',style: TextStyle(fontFamily: 'Lexend',fontWeight: FontWeight.w600,color: Colors.white),),
      ),
      body: Stack(
        children: [
          const InternetConnection(),
          DashChat(
            typingUsers: typing,
            inputOptions: InputOptions(
                sendButtonBuilder: (send) {
                  return IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: send,
                    color: Colors.grey.shade100,
                  );
                },
                sendOnEnter: true,
                alwaysShowSend: true,
                inputMaxLines: 1,
                inputToolbarPadding: const EdgeInsets.symmetric(horizontal: 10),
                inputToolbarMargin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                inputToolbarStyle: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1,
                        color: Colors.grey.shade800
                    ),
                    color: const Color(0xff121F33)
                ),
                inputTextStyle: const TextStyle(color: Colors.white,fontFamily: 'Lexend'),
                cursorStyle: const CursorStyle(
                    color: Color(0xff1D74F5)
                ),
                inputDecoration: InputDecoration(
                    filled: false,
                    border: InputBorder.none,
                    hintText: 'Message Talkio...',
                    hintStyle: TextStyle(color: Colors.grey.shade600)

                )
            ), //send button code
            currentUser: myself,
            onSend: (ChatMessage m){
              getData(m);
            },
            messages: allMessage,
            messageOptions: MessageOptions(
              containerColor:  const Color(0xff121F33),
              currentUserContainerColor:  const Color(0xff1D74F5),
              textColor: Colors.white,
              borderRadius: 10,
              avatarBuilder: (p0, onPressAvatar, onLongPressAvatar) {
                return Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 40,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: const DecorationImage(image: AssetImage('assets/images/icon.png'))
                  ),
                );
              },
              messageTextBuilder: (message, previousMessage, nextMessage) {
                return Text(message.text,style: const TextStyle(fontFamily: 'Lexend',color: Colors.white),);
              },//message body font family
              onLongPressMessage: (ChatMessage message) {
                Clipboard.setData(ClipboardData(text: message.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }, // long press copy
            ),

          ),
        ],
      ),

    );
  }
}
