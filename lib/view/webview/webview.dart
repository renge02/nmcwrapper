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
    required this.userData,
    required this.webUrl,
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
      Permission.photos,
    ].request();
  }

  String _normalizeLocale(String? raw) {
    final v = (raw ?? '').trim().toLowerCase();

    if (v == 'en' || v == 'english' || v.startsWith('en_')) return 'en_IN';
    if (v == 'mr' || v == 'marathi' || v.startsWith('mr_')) return 'mr_IN';
    if (v == 'hi' || v == 'hindi' || v.startsWith('hi_')) return 'hi_IN';

    final exactLocale = RegExp(r'^[a-z]{2}_[A-Z]{2}$');
    if (exactLocale.hasMatch(raw ?? '')) return raw!;

    return 'en_IN';
  }

  Future<void> injectSession() async {
    if (controller == null || isInjected) return;

    final storedLanguage = await getIt<SecureStorage>().getLanguage();
    final locale = _normalizeLocale(storedLanguage);

    isInjected = true;

    final String escapedUserData = jsonEncode(widget.userData);
    final String escapedToken = jsonEncode(widget.token);
    final String escapedLocale = jsonEncode(locale);

    await controller!.evaluateJavascript(source: """
      (function () {
        try {
          const raw = JSON.parse($escapedUserData);
          const user = (typeof raw === 'string') ? JSON.parse(raw) : raw;
          const token = $escapedToken;
          const locale = $escapedLocale;

          const now = Date.now();
          const ttl = 86400; // 24h
          const pack = (value) => JSON.stringify({
            value: value,
            ttl: ttl,
            expiry: now + ttl * 1000
          });

          // Digit user/session keys
          sessionStorage.setItem('Digit.User', pack(user));
          localStorage.setItem('Digit.User', pack(user));

          sessionStorage.setItem('Digit.userType', pack('citizen'));
          sessionStorage.setItem('Digit.user_type', pack('citizen'));
          localStorage.setItem('Digit.userType', pack('citizen'));
          localStorage.setItem('Digit.user_type', pack('citizen'));

          // Token keys
          localStorage.setItem('token', token);
          localStorage.setItem('Citizen.token', token);

          // Locale keys used by web app
          sessionStorage.setItem('Digit.locale', pack(locale));
          localStorage.setItem('Digit.locale', pack(locale));
          localStorage.setItem('locale', locale);
          localStorage.setItem('Citizen.locale', locale);

          // User info keys
          const info = user.info || user.UserRequest || user;
          localStorage.setItem('user-info', JSON.stringify(info));
          localStorage.setItem('Citizen.user-info', JSON.stringify(info));

          // Keep selectedLanguage in Digit.initData for screens reading this path
          let initData = { value: {} };
          try {
            const existing = sessionStorage.getItem('Digit.initData');
            if (existing) initData = JSON.parse(existing);
            if (!initData.value) initData.value = {};
          } catch (e) {}

          initData.value.selectedLanguage = locale;
          sessionStorage.setItem('Digit.initData', JSON.stringify(initData));

          // Try runtime language switch
          const tenantId = info?.tenantId || 'pg.cityb';
          const stateCode = String(tenantId).split('.')[0];

          if (window.Digit?.LocalizationService?.changeLanguage) {
            window.Digit.LocalizationService.changeLanguage(locale, stateCode);
          } else if (window.i18next?.changeLanguage) {
            window.i18next.changeLanguage(locale);
          }
        } catch (e) {
          console.error('WebView injection failed', e);
        }
      })();
    """);

    await Future.delayed(const Duration(milliseconds: 250));
    await controller!.reload();
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
                geolocationEnabled: true,
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

                // Logout detection
                if (url == webUrlRequest) {
                  await getIt<SecureStorage>().deleteAll();

                  if (!mounted) return NavigationActionPolicy.CANCEL;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );

                  return NavigationActionPolicy.CANCEL;
                }

                // Phone / mail / sms
                if (url.startsWith("tel:") ||
                    url.startsWith("mailto:") ||
                    url.startsWith("sms:")) {
                  await launchUrl(uri);
                  return NavigationActionPolicy.CANCEL;
                }

                // External apps
                if (url.contains("whatsapp") || url.startsWith("intent:")) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  return NavigationActionPolicy.CANCEL;
                }

                // File downloads
                if (url.endsWith(".pdf") ||
                    url.endsWith(".jpg") ||
                    url.endsWith(".png")) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  return NavigationActionPolicy.CANCEL;
                }

                return NavigationActionPolicy.ALLOW;
              },
              onGeolocationPermissionsShowPrompt: (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                  origin: origin,
                  allow: true,
                  retain: true,
                );
              },
              androidOnPermissionRequest: (controller, origin, resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
            ),
            if (isLoading)
              Container(
                color: Colors.white70,
                child: const Center(child: CircularProgressIndicator()),

              ),
          ],
        ),
      ),
    );
  }
}