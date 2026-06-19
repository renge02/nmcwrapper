import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/l10n/app_localizations.dart';
import 'package:nmc_wrapper/repository/loginRepo/login.repo.dart';
import 'package:nmc_wrapper/repository/registerRepo/register.repo.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/navigator_observer.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/dashboard/dashboard.dart';
import 'package:nmc_wrapper/view/login/login.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  runApp(AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark,
    child: MultiProvider(providers: [

      ChangeNotifierProvider(create: (_) => RegisterProvider()),

    ], child: const MyApp()),
  ));
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(),
      ),
      locale: Locale('en'),
      // locale: getIt<LanguageProvider>().locale,
      supportedLocales: const [
        Locale('en'),
        Locale('mr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
      themeMode: ThemeMode.system,
      navigatorObservers: [customObserver],
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final textScaler = mediaQueryData.textScaler.clamp(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.3,
        );

        return MediaQuery(
          data: mediaQueryData.copyWith(textScaler: textScaler),
          child: child!,
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveNext(2);
  }



  moveNextOLD(int time) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: time), () async {
        await getIt<SecureStorage>().getUserData().then((value) {
          if (value != null) {
            context.pushReplacementWidget(const DashboardScreen());
          } else {
            context.pushReplacementWidget(const LoginScreen());
          }
        });
      });
    });
  }

  void moveNext(int time) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: time), () async {
        try {
          debugPrint("Splash started");

          final value = await getIt<SecureStorage>().getUserData();

          debugPrint("UserData: $value");

          if (!mounted) return;

          if (value != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const DashboardScreen(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          }
        } catch (e, stack) {
          debugPrint("Splash Error: $e");
          debugPrint("$stack");

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/app_logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),

        ],
      ),
    );
  }
}
