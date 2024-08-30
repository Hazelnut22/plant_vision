import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_vision/post.dart';
import 'package:plant_vision/style.dart';

class PlantChat extends StatefulWidget {
  @override
  State<PlantChat> createState() => _PlantChatState();
}

class _PlantChatState extends State<PlantChat> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final Post post = Post(
    url2: 'http://192.168.100.24:8000/',
    endpoint: 'chat/get'
  );

  final _formKey = GlobalKey<FormState>();
  
  String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  Future<void> _sendMessage(String text) async {
    final primaryUrl = Uri.parse(post.getFallbackUrl()); // Primary URL
    final fallbackUrl = Uri.parse(post.getPrimaryUrl()); //fallback URL

    try {
      String jsonBody = jsonEncode({'msg': text});
      final response = await http.post(primaryUrl, body: jsonBody, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        final now = DateTime.now(); // Local current time
        
        setState(() {
          _messages.add({
            'text': text,
            'type': 'user',
            'timestamp': formatTime(now),
          });
          _messages.add({
            'text': responseData['response'],
            'type': 'bot',
            'timestamp': responseData['timestamp'] ?? formatTime(now), // Fallback to local time if not provided
          });
        });
      } else {
        // If primary URL fails, try the fallback URL
        final fallbackResponse = await http.post(
          fallbackUrl,
          body: jsonBody,
          headers: {'Content-Type': 'application/json'},
        );

        if (fallbackResponse.statusCode == 200) {
          var responseData = jsonDecode(fallbackResponse.body);
          final now = DateTime.now(); // Local current time

          setState(() {
            _messages.add({
              'text': text,
              'type': 'user',
              'timestamp': formatTime(now),
            });
            _messages.add({
              'text': responseData['response'],
              'type': 'bot',
              'timestamp': responseData['timestamp'] ?? formatTime(now), // Fallback to local time if not provided
            });
          });
        } else {
          final now = DateTime.now(); // Local current time

          setState(() {
            _messages.add({
              'text': 'Error: Could not send message',
              'type': 'error',
              'timestamp': formatTime(now),
            });
          });
        }
      }
    } catch (e) {
      print('Error: $e');
      final now = DateTime.now(); // Local current time

      setState(() {
        _messages.add({
          'text': 'Error: Could not send message',
          'type': 'error',
          'timestamp': formatTime(now),
        });
      });
    }
    _controller.clear();
    _formKey.currentState?.reset();
  }

  void _refreshChat() {
    setState(() {
      _messages.clear(); // Clear all messages
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBgColor,
       appBar: AppBar(
        backgroundColor: kBgColor,
        automaticallyImplyLeading: false,
        title: SafeArea(
          child: Text(
            AppLocalizations.of(context)!.chatbot,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: kColorPakistanGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        titleSpacing: 4.0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                size: 30.0,
                color: kColorPakistanGreen,
                ),
              onPressed: _refreshChat,
            ),
          ),
        ],
      ),
       body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final messageText = message['text']!;
                final timestamp = message['timestamp']!;
                final isUser = message['type'] == 'user';
                final isError = message['type'] == 'error';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
                      decoration: BoxDecoration(
                        color: isUser ? kColorCalPolyGreen.withOpacity(0.5) : kColorYellowGreen.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            messageText,
                            style: TextStyle(
                              color: isError ? kColorRed : (isUser ? kColorLavenderBlush : kLicorice),
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            timestamp,
                            style: TextStyle(
                              fontFamily: kDisplayFont,
                              color: kColorLavenderBlush,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      cursorColor: kColorPakistanGreen,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: kColorYellowGreen,
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: kColorPakistanGreen,
                            width: 2.0,
                          ),
                        ),
                        hintText: AppLocalizations.of(context)!.askMe,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.enterValue(AppLocalizations.of(context)!.question); // Validation message
                        }
                        return null;
                      },
                      onFieldSubmitted: (text) {
                        _sendMessage(text);
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _sendMessage(_controller.text);
                      }
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: kColorYellowGreen.withOpacity(0.3),
                      child: Icon(
                        Icons.send,
                        size: 30.0,
                        color: kColorPakistanGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
