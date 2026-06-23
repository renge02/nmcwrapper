import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/repository/language/LanguageProvider.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/important_contacts/helpline_screen.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_alert.dart';
import 'package:nmc_wrapper/view/webview/webview.dart';
import 'package:nmc_wrapper/view/webview/webview_Page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = '';

  String? rolesString = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    userName = await getIt<SecureStorage>().getUserName() ?? '';
    rolesString = await getIt<SecureStorage>().getRole();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF2E9E8),
      drawer: buildDrawer(),

      /// APP BAR
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),

        elevation: 0,
        backgroundColor: AppTheme.appBarColor,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${AppStrings.translate(context, 'hello')}, $userName',
              style: GoogleFonts.notoSans(fontSize: 14, color: Colors.white),
            ),
            Text(
              '${AppStrings.translate(context, 'role')}: $rolesString',
              style: GoogleFonts.notoSans(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.white),
            color: Colors.white,
            elevation: 8,
            offset: const Offset(0, 45),
            onSelected: (value) {
              print("Selected Language: $value");

              context.read<LanguageProvider>().changeLanguage(value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: "en",
                child: Text(
                  "ENGLISH",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const PopupMenuItem<String>(
                value: "mr",
                child: Text(
                  "मराठी",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
          /*   IconButton(
            onPressed: () {
              showLogoutAlert(context: context);
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),*/
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSection(
                title: AppStrings.translate(context, 'all_services'),
                items: services,
              ),

              buildSection(
                title: AppStrings.translate(context, 'civic_services'),
                items: civicServices,
              ),
              buildSection(
                title: AppStrings.translate(context, 'connect_now'),
                items: socialMediaServices,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer() {
    String getInitials(String name) {
      if (name.trim().isEmpty) return "";

      List<String> parts = name.trim().split(" ");

      if (parts.length == 1) {
        return parts.first[0].toUpperCase();
      }

      return "${parts.first[0]}${parts.last[0]}".toUpperCase();
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            /// Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
              color: AppTheme.appBarColor,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Text(
                      getInitials(userName),
                      style: GoogleFonts.notoSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.appBarColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    userName,
                    style: GoogleFonts.notoSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '$rolesString',
                    style: GoogleFonts.notoSans(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            buildDrawerItem(
              Icons.person_outline,
              AppStrings.translate(context, 'profile'),
              () {},
            ),

            emergencyDrawerItem(),

            const Spacer(),

            const Divider(),

            buildDrawerItem(
              Icons.logout,
              AppStrings.translate(context, 'logout'),
              () {
                Navigator.pop(context);
                showLogoutAlert(context: context);
              },
              iconColor: AppTheme.appBarColor,
              textColor: AppTheme.appBarColor,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color iconColor = Colors.black87,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.notoSans(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget emergencyDrawerItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Text(
                AppStrings.translate(context, 'emergency_use_only'),
                style: GoogleFonts.notoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          emergencyTile(AppStrings.translate(context, 'police'), "100"),
          emergencyTile(AppStrings.translate(context, 'ambulance'), "108"),
          emergencyTile(AppStrings.translate(context, 'fire_brigade'), "101"),
          emergencyTile(
            AppStrings.translate(context, 'nmc_call_center'),
            "7030300300",
          ),
        ],
      ),
    );
  }

  Widget emergencyTile(String title, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.notoSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          InkWell(
            onTap: () {
              // Call functionality
              launchUrl(Uri.parse("tel:$number"));
            },
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xff1ABC9C),
              child: const Icon(Icons.call, size: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSection({required String title, required List<Service> items}) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSans(fontSize: 18, color: Color(0xff7A1E1C)),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            itemCount: items.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),

            itemBuilder: (_, index) {
              return ServiceCard(item: items[index]);
            },
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Service item;

  const ServiceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => item.onTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Padding(
          padding: const EdgeInsets.all(5),

          child: item.title.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Image.asset(item.image, width: 18, height: 18),
                    const SizedBox(height: 5),
                    Text(
                      AppStrings.translate(context, item.title),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      style: GoogleFonts.notoSans(fontSize: 10),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset(item.image, width: 30, height: 30)],
                ),
        ),
      ),
    );
  }
}

class Service {
  final String title;

  final String image;
  final Function(BuildContext) onTap;

  Service(this.title, this.image, {required this.onTap});
}

List<Service> services = [
  Service(
    'grievance_redressal',
    "assets/images/sentiment_emoji.png",
    onTap: (context) async {
      String token = await getIt<SecureStorage>().getToken() ?? '';
      String userData = await getIt<SecureStorage>().getUserData() ?? '';
      String webUrl = 'https://dev-upyog.nmc.gov.in/upyog-ui/citizen/pgr-home';
      context.pushWidget(
        WebPage(webUrl: webUrl, token: token, userData: userData),
      );
    },
  ),

  Service(
    "marriage_registration",
    "assets/images/marriage_regis.png",
    onTap: (context) async {
      String accessToken = await getIt<SecureStorage>().getToken() ?? '';
      String userData = await getIt<SecureStorage>().getUserData() ?? '';

      String tenantId = "pg";
      String logoutRedirectUrl =
          "https://dev-upyog.nmc.gov.in/upyog-ui/citizen/bap-logout";

      String webUrl =
          "https://dev-upyog.nmc.gov.in/nmc/en/investor/services/968.0/apply/1"
          "?accessToken=$accessToken"
          "&tenantId=$tenantId"
          "&logoutRedirectUrl=${Uri.encodeComponent(logoutRedirectUrl)}";

      context.pushWidget(
        WebPage(
          webUrl: webUrl,
          token: accessToken,
          userData: userData,
        ),
      );
    },
  ),
  Service(
    "challan_payment",
    "assets/images/accounting_bal.png",
    onTap: (context) async {
      String token = await getIt<SecureStorage>().getToken() ?? '';
      String userData = await getIt<SecureStorage>().getUserData() ?? '';
      final String webUrl =
          'https://dev-upyog.nmc.gov.in/upyog-ui/citizen/mcollect-home';

      context.pushWidget(
        WebPage(webUrl: webUrl, token: token, userData: userData),
      );
    },
  ),
  Service(
    "trade_license",
    "assets/images/trade_lic.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "hoarding_permission",
    "assets/images/hoarding_per.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "tree_cutting_permission",
    "assets/images/tree.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "noc_issuance",
    "assets/images/noc.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "water_connection",
    "assets/images/home.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "birth_death",
    "assets/images/p_women.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "health_facility",
    "assets/images/hospital.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "property_tax",
    "assets/images/property_tax.png",
    onTap: (context) {
      openUrl("https://propertytax.nmctax.in/");
    },
  ),
];

List<Service> civicServices = [
  Service(
    "civic_services",
    "assets/images/family.png",
    onTap: (context) {
      openUrl('https://civicservices.nmc.gov.in/login');
    },
  ),

  Service(
    "news",
    "assets/images/news.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "faq",
    "assets/images/faq.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "nmc_help_center",
    "assets/images/help.png",
    onTap: (context) {
      callFunction(context);
    },
  ),

  Service(
    "know_our_works",
    "assets/images/work.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "elected_members",
    "assets/images/election.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "administration",
    "assets/images/admin.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.translate(context, 'coming_soon'))),
      );
    },
  ),

  Service(
    "important_contacts",
    "assets/images/add_call.png",
    onTap: (context) {
      // openUrl('https://nmc.gov.in/home/getfrontpage/7/191/E#tabs|History:tab1');
      context.pushWidget(HelplineScreen());
    },
  ),
];

callFunction(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListTile(
              leading: const Icon(Icons.call),
              title: Text(AppStrings.translate(context, 'help_center_timing')),
              subtitle: Text("7030300300"),
              onTap: () => makePhoneCall("7030300300"),
            ),
          ),
        ],
      );
    },
  );
}

List<Service> socialMediaServices = [
  Service(
    "",
    "assets/images/facebook.png",
    onTap: (context) {
      openUrl('https://www.facebook.com/mynashikmc/');
    },
  ),

  Service(
    "",
    "assets/images/group.png",
    onTap: (context) {
      openUrl('https://x.com/my_nmc');
    },
  ),

  Service(
    "",
    "assets/images/youtube.png",
    onTap: (context) {
      openUrl('https://www.youtube.com/c/mynmc');
    },
  ),
  Service(
    "",
    "assets/images/instagram.png",
    onTap: (context) {
      openUrl('https://www.instagram.com/my_nmc');
    },
  ),
];

Future<void> openUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
