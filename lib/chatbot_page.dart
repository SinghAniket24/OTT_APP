import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:ui' as ui; // For web
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // For web
import 'package:webview_flutter/webview_flutter.dart'; // For mobile

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  late final WebViewController _controller;

  final String _htmlContent = ''' 
  <!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin:0; padding:0;">
  <script src="https://cdn.jotfor.ms/s/umd/latest/for-embedded-agent.js"></script>
  <script>
    window.addEventListener("DOMContentLoaded", function() {
      window.AgentInitializer.init({
        agentRenderURL: "https://agent.jotform.com/0196aece758a749fa2738b2c064c255c9c2e",
        rootId: "JotformAgent-0196aece758a749fa2738b2c064c255c9c2e",
        formID: "0196aece758a749fa2738b2c064c255c9c2e",
        queryParams: ["skipWelcome=1", "maximizable=1"],
        domain: "https://www.jotform.com",
        isDraggable: false,
        background: "linear-gradient(180deg, #D3CBF4 0%, #D3CBF4 100%)",
        buttonBackgroundColor: "#8797FF",
        buttonIconColor: "#01091B",
        variant: false,
        customizations: {
          "greeting": "Yes",
          "greetingMessage": "Hi! How can I assist you?",
          "openByDefault": "No",
          "pulse": "Yes",
          "position": "right",
          "autoOpenChatIn": "0"
        },
        isVoice: false
      });
    });
  </script>
</body>
</html>
  ''';  

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadHtmlString(_htmlContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define your gradient colors here
    const gradient = LinearGradient(
      colors: [Color(0xFF8797FF), Color(0xFF191A1E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    if (kIsWeb) {
      // Register iframe for web
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        'chatbot-html',
        (int viewId) => html.IFrameElement()
          ..src = '/chatbot.html'
          ..style.border = 'none'
          ..style.width = '100vw'
          ..style.height = '100vh',
      );
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Chatbot'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight), // Add padding to avoid overlap
          child: Container(
            decoration: const BoxDecoration(gradient: gradient),
            width: double.infinity,
            height: double.infinity,
            child: const HtmlElementView(viewType: 'chatbot-html'),
          ),
        ),
      );
    } else {
      // Use WebView for mobile
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Chatbot'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight), // Add padding to avoid overlap
          child: Container(
            decoration: const BoxDecoration(gradient: gradient),
            width: double.infinity,
            height: double.infinity,
            child: WebViewWidget(controller: _controller),
          ),
        ),
      );
    }
  }
}
