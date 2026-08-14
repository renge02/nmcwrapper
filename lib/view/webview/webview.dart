import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nmc_wrapper/data/remote/network/api.end.points.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/login/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';

class WebPage extends StatefulWidget {
  final String token;
  final String webUrl;
  final String userData;
  final String userType;

  const WebPage({
    super.key,
    required this.token,
    required this.userData,
    required this.webUrl,
    this.userType = 'CITIZEN',
  });

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  InAppWebViewController? controller;

  final String webUrlRequest = '${ApiEndPoints.baseAPIUrl}/upyog-ui/citizen';
  final String webDeptUrlRequest =
      '${ApiEndPoints.baseAPIUrl}/upyog-ui/employee/user/login';
  final String loginURL = "${ApiEndPoints.baseAPIUrl}/upyog-ui/citizen/login";

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
    final String escapedTenantId = jsonEncode("pg.cityb");
    final escapedUserType = jsonEncode(widget.userType);

    await controller!.evaluateJavascript(
      source:
          '''
       (function () {
  try {
    const raw = JSON.parse($escapedUserData);
    const user = (typeof raw === 'string') ? JSON.parse(raw) : raw;

    const token = $escapedToken;
    const userType = $escapedUserType;
    const tenantId = $escapedTenantId;
    const locale = $escapedLocale;

    const userInfo = JSON.stringify(user.info || user.UserRequest || user);

    const now = Date.now();
    const ttl = 86400;

    const pack = (value) => JSON.stringify({
      value: value,
      ttl: ttl,
      expiry: now + ttl * 1000
    });

    // Digit User
    sessionStorage.setItem('Digit.User', pack(user));
    localStorage.setItem('Digit.User', pack(user));

    // User Type
    sessionStorage.setItem('Digit.userType', pack(userType));
    sessionStorage.setItem('Digit.user_type', pack(userType));
    localStorage.setItem('Digit.userType', pack(userType));
    localStorage.setItem('Digit.user_type', pack(userType));

    // Locale
    sessionStorage.setItem('Digit.locale', pack(locale));
    localStorage.setItem('Digit.locale', pack(locale));

    // Generic keys
    localStorage.setItem('token', token);
    localStorage.setItem('tenant-id', tenantId);
    localStorage.setItem('user-info', userInfo);
    localStorage.setItem('locale', locale);

    // Role specific keys
    if (userType === "EMPLOYEE") {

      localStorage.setItem('Employee.token', token);
      localStorage.setItem('Employee.tenant-id', tenantId);
      localStorage.setItem('Employee.user-info', userInfo);
      localStorage.setItem('Employee.locale', locale);

    } else {

      localStorage.setItem('Citizen.token', token);
      localStorage.setItem('Citizen.tenant-id', tenantId);
      localStorage.setItem('Citizen.user-info', userInfo);
      localStorage.setItem('Citizen.locale', locale);

    }

  } catch (e) {
    console.error("WebView token injection failed", e);
  }
})();''',
    );

    /* await controller!.evaluateJavascript(
      source:
          """
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
    """,
    );*/

    await Future.delayed(const Duration(milliseconds: 250));
    await controller!.reload();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.webUrl)),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,

                  javaScriptCanOpenWindowsAutomatically: true,
                  supportMultipleWindows: true,

                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                  useHybridComposition: true,
                  geolocationEnabled: true,
                  preferredContentMode: UserPreferredContentMode.DESKTOP,
                ),
                onWebViewCreated: (ctrl) {
                  controller = ctrl;

                  ctrl.addJavaScriptHandler(
                    handlerName: 'downloadBlob',
                    callback: (args) async {
                      if (args.isEmpty) return;

                      final data = args[0];

                      final String base64Data = data['data'];
                      final String fileName = data['fileName'];

                      await saveBase64File(base64Data, "acknowledgement-$fileName");
                    },
                  );

                  ctrl.addJavaScriptHandler(
                    handlerName: 'printPage',
                    callback: (args) async {
                      debugPrint('========== PRINT REQUESTED ==========');

                      try {
                        await ctrl.printCurrentPage();

                        debugPrint('Print dialog requested');
                      } catch (e) {
                        debugPrint('Print error: $e');
                      }

                      return true;
                    },
                  );
                },
                onLoadStart: (ctrl, url) {
                  setState(() => isLoading = true);
                },
                onLoadStop: (ctrl, url) async {
                  await injectSession();

                  await ctrl.evaluateJavascript(
                    source: '''
      (function() {
        try {
          if (!window.__flutterPrintOverridden) {

            window.__originalPrint = window.print;

            window.print = function() {
              console.log("Flutter print called");

              window.flutter_inappwebview.callHandler(
                'printPage'
              );
            };

            window.__flutterPrintOverridden = true;
          }
        } catch (e) {
          console.error("Print override error:", e);
        }
      })();
    ''',
                  );

                  if (mounted) {
                    setState(() => isLoading = false);
                  }
                },

                onDownloadStartRequest: (controller, downloadRequest) async {
                  final url = downloadRequest.url.toString();
                  final fileName =
                      downloadRequest.suggestedFilename ?? 'download.csv';

                  debugPrint('========== DOWNLOAD ==========');
                  debugPrint('URL: $url');
                  debugPrint('File name: $fileName');
                  debugPrint('MIME type: ${downloadRequest.mimeType}');
                  debugPrint('==============================');

                  if (url.startsWith('blob:')) {
                    await controller.evaluateJavascript(
                      source:
                          '''
        (async function() {
          try {
            const response = await fetch('$url');
            const blob = await response.blob();

            const reader = new FileReader();

            reader.onloadend = function() {
              const base64 = reader.result.split(',')[1];

              window.flutter_inappwebview.callHandler(
                'downloadBlob',
                {
                  data: base64,
                  fileName: '$fileName'
                }
              );
            };

            reader.readAsDataURL(blob);
          } catch (error) {
            console.error('Blob download error:', error);
          }
        })();
      ''',
                    );

                    return;
                  }

                  // Normal HTTP/HTTPS download
                  await downloadFile(url, fileName);
                },

                shouldOverrideUrlLoading: (ctrl, action) async {
                  final uri = action.request.url;
                  if (uri == null) return NavigationActionPolicy.ALLOW;

                  final url = uri.toString();

                  // Logout detection
                  if (url == webUrlRequest ||
                      url == webDeptUrlRequest ||
                      url == loginURL) {
                    await getIt<SecureStorage>().deleteAll();

                    if (!mounted) return NavigationActionPolicy.CANCEL;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          index: url == webDeptUrlRequest ? 1 : 0,
                        ),
                      ),
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
                  if (url.contains("whatsapp") ||
                      url.startsWith("intent:") ||
                      url.startsWith("upi:")) {
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
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                      return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT,
                      );
                    },
                onReceivedError: (controller, request, error) async {
                  final uri = request.url;

                  if (uri.scheme == "upi") {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  debugPrint('VISITED URL: $url');
                },
                onCreateWindow: (controller, request) async {
                  final uri = request.request.url;

                  debugPrint('========== POPUP ==========');
                  debugPrint('Popup URL: $uri');
                  debugPrint('============================');

                  if (uri == null) {
                    return false;
                  }

                  // UPI
                  if (uri.scheme == 'upi') {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );

                    return false;
                  }

                  // Intent
                  if (uri.scheme == 'intent') {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );

                    return false;
                  }

                  // Normal popup / print page
                  debugPrint('Loading popup/print URL in current WebView');

                  await controller.loadUrl(
                    urlRequest: URLRequest(
                      url: uri,
                    ),
                  );

                  return false;
                },              ),

              if (isLoading)
                Container(
                  color: Colors.white70,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveBase64File(String base64Data, String fileName) async {
    try {
      final bytes = base64Decode(base64Data);

      final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD,
      );

      final filePath = '$downloadPath/$fileName';

      final file = File(filePath);

      await file.writeAsBytes(bytes, flush: true);

      debugPrint('========== FILE SAVED ==========');
      debugPrint('File: ${file.path}');
      debugPrint('Exists: ${await file.exists()}');
      debugPrint('Size: ${await file.length()} bytes');
      debugPrint('================================');
    } catch (e, stackTrace) {
      debugPrint('Save file error: $e');
      debugPrint('$stackTrace');
    }
  }

  Future<void> downloadFile(
      String url,
      String? suggestedFilename,
      ) async {
    try {
      // Get WebView cookies
      final cookies = await CookieManager.instance().getCookies(
        url: WebUri(url),
      );

      final cookieHeader = cookies
          .map((cookie) => '${cookie.name}=${cookie.value}')
          .join('; ');

      debugPrint('========== DOWNLOAD ==========');
      debugPrint('URL: $url');
      debugPrint('Cookies available: ${cookies.length}');

      // Get public Downloads directory
      final downloadPath =
      await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD,
      );

      debugPrint('Download directory: $downloadPath');

      // Static filename
      const String fileName = 'acknowledgement.pdf';

      final filePath = '$downloadPath/$fileName';

      debugPrint('Saving to: $filePath');

      final dio = Dio();

      await dio.download(
        url,
        filePath,
        options: Options(
          headers: {
            'Cookie': cookieHeader,
            'Accept': '*/*',
          },
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) {
            return status != null && status >= 200 && status < 400;
          },
        ),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress =
            (received / total * 100).toStringAsFixed(0);

            debugPrint('Download: $progress%');
          }
        },
      );

      final file = File(filePath);

      if (await file.exists()) {
        final size = await file.length();

        debugPrint('========== DOWNLOAD COMPLETE ==========');
        debugPrint('File: ${file.path}');
        debugPrint('Size: $size bytes');
        debugPrint('========================================');
      } else {
        debugPrint('File was not created');
      }
    } catch (e, stackTrace) {
      debugPrint('========== DOWNLOAD ERROR ==========');
      debugPrint('ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('===================================');
    }
  }
}
