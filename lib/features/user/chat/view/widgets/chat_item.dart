import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/core/utils/hexcolor.dart';
import 'package:upi_pay/features/user/chat/model/message.dart';

class ChatItem extends ConsumerWidget {
  final Message message;
  const ChatItem({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.of(context).size.width;
    String username = "User";
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = Color(0xFF6C63FF); // Purple accent color
    final shadowColor = isDarkMode ? Colors.black54 : Colors.black12;
    
    // Message time formatting
    final now = DateTime.now();
    final messageTime = DateFormat('h:mm a').format(now);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.only(bottom: 4),
      child: message.isUser
          ? Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Message content
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(
                        maxWidth: width * 0.75,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Image attachment if exists
                            if (message.image != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 200,
                                    maxWidth: width * 0.6,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Image.file(
                                    message.image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            
                            // Message text
                            Text(
                              message.text,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            
                            // Message timestamp
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                messageTime,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // User avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/icons/user.png'),
                    ),
                  ),
                ],
              ),
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Bot avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/icons/bot.png',
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  
                  // Message content
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(
                        maxWidth: width * 0.75,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Emphasize welcome message if it's the greeting
                            if (message.text == 'Hello @$username! How can I help you?')
                              Text(
                                message.text,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
                              )
                            else
                              Text(
                                message.text,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
                              ),
                            
                            // Message timestamp
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                messageTime,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}