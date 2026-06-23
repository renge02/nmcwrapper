import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/login/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class WebPage extends StatefulWidget {
  final String token;
  final String webUrl;
  final String userData;

  const WebPage({
    super.key,
    required this.token,
    required this.userData, required this.webUrl,
  });


  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  InAppWebViewController? controller;

  final String webUrlRequest = 'https://dev-upyog.nmc.gov.in/upyog-ui/citizen';


  bool isInjected = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
      Permission.location,
      Permission.photos
    ].request();
  }

  Future<void> injectSession() async {
    if (controller == null || isInjected) return;

    isInjected = true;
    final String escapedUserData = jsonEncode(widget.userData);
    final String escapedToken = jsonEncode(widget.token);
    await controller!.evaluateJavascript(source: """
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
    """);

    await Future.delayed(Duration(milliseconds: 200));
    controller!.reload();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.webUrl)),
        
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                useHybridComposition: true,
                geolocationEnabled: true
              ),
        
              onWebViewCreated: (ctrl) {
                controller = ctrl;
              },
        
              onLoadStart: (ctrl, url) {
                setState(() => isLoading = true);
              },
        
              onLoadStop: (ctrl, url) async {
                await injectSession();
                setState(() => isLoading = false);
              },
        
              shouldOverrideUrlLoading: (ctrl, action) async {
                final uri = action.request.url;
        
                if (uri == null) return NavigationActionPolicy.ALLOW;
        
                final url = uri.toString();
        
        
                /// LOGOUT DETECTION
                if (url==webUrlRequest) {
                  print(" Logout detected");
        
                  // Clear app session
                  await getIt<SecureStorage>().deleteAll();
        
                  if (!mounted) return NavigationActionPolicy.CANCEL;
        
                  // Navigate to Login (clear stack)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                        (route) => false,
                  );
        
                  return NavigationActionPolicy.CANCEL;
                }
                // PHONE
                if (url.startsWith("tel:") ||
                    url.startsWith("mailto:") ||
                    url.startsWith("sms:")) {
                  await launchUrl(uri);
                  return NavigationActionPolicy.CANCEL;
                }
        
                // EXTERNAL APPS
                if (url.contains("whatsapp") || url.startsWith("intent:")) {
                  await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                  return NavigationActionPolicy.CANCEL;
                }
        
                // DOWNLOAD FILES
                if (url.endsWith(".pdf") ||
                    url.endsWith(".jpg") ||
                    url.endsWith(".png")) {
                  await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                  return NavigationActionPolicy.CANCEL;
                }
        
                return NavigationActionPolicy.ALLOW;
              },
              onGeolocationPermissionsShowPrompt:
                  (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                  origin: origin,
                  allow: true,
                  retain: true,
                );
              },
              // FILE UPLOAD SUPPORT
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
            ),
        
            // LOADER
            if (isLoading)
              Container(
                color: Colors.white70,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}