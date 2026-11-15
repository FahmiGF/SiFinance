import 'package:flutter/material.dart';

import 'features/chat/data/chat_service.dart';
import 'features/chat/presentation/chat_page.dart';

class SiFinanceApp extends StatelessWidget {
  const SiFinanceApp({super.key, this.chatService});

  final ChatService? chatService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiFinance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF004CFF),
          primary: const Color(0xFF004CFF),
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 12,
            letterSpacing: 0,
            color: Color(0xFF101828),
          ),
        ),
      ),
      home: ChatPage(service: chatService ?? createChatService()),
    );
  }
}
