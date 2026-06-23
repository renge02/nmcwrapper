import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/view/login/login.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/remote/network/api.end.points.dart';

class WebDashboardPage extends StatefulWidget {
  final String token;
  final String webUrl;
  final String userData;

  const WebDashboardPage({
    super.key,
    required this.token,
    required this.userData, required this.webUrl,
  });

  @override
  State<WebDashboardPage> createState() => _WebDashboardPageState();
}

class _WebDashboardPageState extends State<WebDashboardPage> {
  late final WebViewController _controller;

  // Correct URL string (no markdown formatting)
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
if(Platform.isAndroid){
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

}else{
  await _controller.runJavaScript('''
                (function () {
                  try {
                    const raw = JSON.parse($escapedUserData);
                    const user = (typeof raw === 'string') ? JSON.parse(raw) : raw;
                    const token = $escapedToken;

                    const now = Date.now();
                    const ttl = 86400;

                    const pack = (value) => JSON.stringify({
                      value: value,
                      ttl: ttl,
                      expiry: now + ttl * 1000
                    });

                    sessionStorage.setItem('Digit.User', pack(user));
                    localStorage.setItem('Digit.User', pack(user));

                    sessionStorage.setItem('Digit.userType', pack('citizen'));
                    localStorage.setItem('Digit.userType', pack('citizen'));

                    localStorage.setItem('token', token);
                    localStorage.setItem('Citizen.token', token);

                    const info = user.info || user.UserRequest || user;
                    localStorage.setItem('user-info', JSON.stringify(info));

                    // iOS fix
                    const config = {
                      stateCode: "pg",
                      tenantId: "pg",
                      moduleName: "upyog",
                      apiHost: "${ApiEndPoints.baseAPIUrl}"
                    };

                    window.Digit = window.Digit || {};
                    window.Digit.Config = config;

                    localStorage.setItem('stateCode', "pg");
                    sessionStorage.setItem('stateCode', "pg");

                    window.getConfig = function () {
                      return config;
                    };

                    //  Mobile fix
                    let meta = document.querySelector("meta[name=viewport]");
                    if (!meta) {
                      meta = document.createElement('meta');
                      meta.name = "viewport";
                      document.head.appendChild(meta);
                    }
                    meta.content = "width=device-width, initial-scale=1.0";

                    document.body.style.overflowX = "hidden";
                    document.documentElement.style.overflowX = "hidden";

                  } catch (e) {
                    console.error("Injection failed", e);
                  }
                })();
              ''');

}

            // Reload once so route guards read injected session
            await _controller.reload();
          },
          onNavigationRequest: (request) {



            if (!isHandled && request.url==webUrlRequest) {

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

      ..loadRequest(Uri.parse(widget.webUrl));
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