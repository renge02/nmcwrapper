import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/view/login/login.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebDashboardPage extends StatefulWidget {
  final String token;
  final String userData; // Expected: JSON string of user object

  const WebDashboardPage({
    super.key,
    required this.token,
    required this.userData,
  });

  @override
  State<WebDashboardPage> createState() => _WebDashboardPageState();
}

class _WebDashboardPageState extends State<WebDashboardPage> {
  late final WebViewController _controller;

  // Correct URL string (no markdown formatting)
  final String webUrl = 'https://dev-upyog.nmc.gov.in/upyog-ui/citizen/pgr-home';
  final String webUrlRequest = 'https://dev-upyog.nmc.gov.in/upyog-ui/citizen';

  bool isTokenInjected = false;
  bool isHandled = false;

  @override
  void initState() {
    super.initState();

    final String escapedUserData = jsonEncode(widget.userData);
    final String escapedToken = jsonEncode(widget.token);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            if (isTokenInjected) return;
            isTokenInjected = true;

            await _controller.runJavaScript('''
              (function () {
                try {
                  const raw = JSON.parse($escapedUserData);
                  const user = (typeof raw === 'string') ? JSON.parse(raw) : raw;
                  const token = $escapedToken;

                  const now = Date.now();
                  const ttl = 86400; // 24 hours
                  const pack = (value) => JSON.stringify({
                    value: value,
                    ttl: ttl,
                    expiry: now + ttl * 1000
                  });

                  // App library storage keys (critical)
                  sessionStorage.setItem('Digit.User', pack(user));
                  localStorage.setItem('Digit.User', pack(user));

                  sessionStorage.setItem('Digit.userType', pack('citizen'));
                  sessionStorage.setItem('Digit.user_type', pack('citizen'));
                  localStorage.setItem('Digit.userType', pack('citizen'));
                  localStorage.setItem('Digit.user_type', pack('citizen'));

                  // Extra keys used in several places
                  localStorage.setItem('token', token);
                  localStorage.setItem('Citizen.token', token);

                  const info = user.info || user.UserRequest || user;
                  localStorage.setItem('user-info', JSON.stringify(info));
                  localStorage.setItem('Citizen.user-info', JSON.stringify(info));
                } catch (e) {
                  console.error('WebView token injection failed', e);
                }
              })();
            ''');

            // Reload once so route guards read injected session
            await _controller.reload();
          },
          onNavigationRequest: (request) {



            if (!isHandled && request.url.contains(webUrlRequest)) {

              isHandled = true;



              ///  Navigate to your specific widget
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(), //  your widget
                ),

              );



              return NavigationDecision.prevent; //  stop loading WebView

            }



            return NavigationDecision.navigate;

          },

        ),
      )
      ..loadRequest(Uri.parse(webUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(
          controller: _controller
      ,)),
    );
  }
}