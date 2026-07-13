import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/data/remote/network/api.end.points.dart';
import 'package:nmc_wrapper/l10n/app_localizations.dart';
import 'package:nmc_wrapper/repository/language/LanguageProvider.dart';
import 'package:nmc_wrapper/repository/loginRepo/login.repo.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/navigator_observer.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/dashboard/dashboard.dart';
import 'package:nmc_wrapper/view/login/login.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';
import 'package:nmc_wrapper/view/webview/webview.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  final languageProvider = LanguageProvider();

  await languageProvider.loadLanguage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),

        ChangeNotifierProvider(create: (_) => RegisterProvider()),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final customObserver = CustomRouteObserver();

    return Consumer<LanguageProvider>(
      builder: (_, provider, _) {
        print(provider.locale);

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          locale: provider.locale,

          supportedLocales: const [Locale('en'), Locale('mr')],

          localizationsDelegates: const [
            AppLocalizations.delegate,

            GlobalMaterialLocalizations.delegate,

            GlobalWidgetsLocalizations.delegate,

            GlobalCupertinoLocalizations.delegate,
          ],

          home: const SplashScreen(),

          navigatorObservers: [customObserver],
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _slideAnimation;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
    moveNext(2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void moveNext(int time) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: time), () async {
        try {
          debugPrint("Splash started");

          final value = await getIt<SecureStorage>().getUserData();

          debugPrint("UserData: $value ");

          if (!mounted) return;

          if (value != null) {
            final Map<String, dynamic> user = jsonDecode(value);
            String userType = user['type'];
            if (userType == "EMPLOYEE") {
              departmentlogin();
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            }
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        } catch (e, stack) {
          debugPrint("Splash Error: $e");
          debugPrint("$stack");

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
    });
  }

  departmentlogin() async {
    String token = await getIt<SecureStorage>().getToken() ?? '';
    String userData = await getIt<SecureStorage>().getUserData() ?? '';
    final String webUrl =
        '${ApiEndPoints.baseAPIUrl}/upyog-ui/employee/pgr/HomeDashboard';
    context.pushReplacementWidget(
      WebPage(
        webUrl: webUrl,
        token: token,
        userData: userData,
        userType: "EMPLOYEE",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBarColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/splash_logo.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
