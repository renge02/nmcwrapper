import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_alert.dart';
import 'package:nmc_wrapper/view/webview/webview_Page.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    userName = await getIt<SecureStorage>().getUserName() ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF2E9E8),
      // drawer: buildDrawer(),

      /// APP BAR
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            userName.isNotEmpty ? userName.trim()[0].toUpperCase() : "",
            style: TextStyle(
              color: AppTheme.appBarColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ).padding(EdgeInsets.all(12)),
        elevation: 0,
        backgroundColor: AppTheme.appBarColor,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, $userName',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              'Role: CITIZEN',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
        actions: [
          /*
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.white),
            color: Colors.white,
            elevation: 8,
            offset: const Offset(0, 45),
            onSelected: (value) {
              print("Selected Language: $value");

              // Change language here
              if (value == "en") {
                // Get.updateLocale(const Locale('en', 'US'));
              } else if (value == "mr") {
                // Get.updateLocale(const Locale('mr', 'IN'));
              }
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
*/
          IconButton(
            onPressed: () {
              showLogoutAlert(context: context);
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSection(title: "All Services", items: services),

              buildSection(title: "Civic Services", items: civicServices),
              buildSection(title: "Connect Now", items: socialMediaServices),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.appBarColor),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                CircleAvatar(
                  radius: 35,

                  backgroundColor: Colors.white,

                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : "",

                    style: const TextStyle(
                      fontSize: 30,

                      color: AppTheme.appBarColor,

                      fontWeight: FontWeight.bold,
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

                Text(
                  "Citizen",

                  style: GoogleFonts.notoSans(
                    color: Colors.white70,

                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          buildDrawerItem(Icons.home_outlined, "Home", () {}),

          buildDrawerItem(Icons.person_outline, "Profile", () {}),

          buildDrawerItem(Icons.language, "Change Language", () {}),

          buildDrawerItem(Icons.help_outline, "Help & Support", () {}),

          buildDrawerItem(Icons.info_outline, "About Us", () {}),

          const Spacer(),

          const Divider(),

          buildDrawerItem(Icons.logout, "Logout", () {
            Navigator.pop(context);

            showLogoutAlert(context: context);
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.appBarColor),

      title: Text(
        title,

        style: GoogleFonts.notoSans(fontSize: 15, fontWeight: FontWeight.w500),
      ),

      onTap: onTap,
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
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 10),
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
    "Grievance\nRedressal",
    "assets/images/sentiment_emoji.png",
    onTap: (context) async {
      String token = await getIt<SecureStorage>().getToken() ?? '';
      String userData = await getIt<SecureStorage>().getUserData() ?? '';
        String webUrl = 'https://dev-upyog.nmc.gov.in/upyog-ui/citizen/pgr-home';
      context.pushWidget(WebDashboardPage(webUrl:webUrl,token: token, userData: userData));
    },
  ),

  Service(
    "Marriage\nRegistration",
    "assets/images/marriage_regis.png",
/*    onTap: (context) async {
      String token = await getIt<SecureStorage>().getToken() ?? '';
      String userData = await getIt<SecureStorage>().getUserData() ?? '';

      String webUrl='https://dev-upyog.nmc.gov.in/nmc/en/investor/services/968.0/apply/1?tenantId=pg&logoutRedirectUrl=https%3A%2F%2Fdev-upyog.nmc.gov.in%2Fupyog-ui%2Fcitizen%2Fbap-logout';
      context.pushWidget(WebDashboardPage(webUrl:webUrl,token: token, userData: userData));

    },*/
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coming soon'),
        ),
      );},
  ),
  Service(
    "Challan\nPayment",
    "assets/images/accounting_bal.png",
    onTap: (context) async {
      String token = await getIt<SecureStorage>().getToken() ?? '';
      String userData = await getIt<SecureStorage>().getUserData() ?? '';
      final String webUrl = 'https://dev-upyog.nmc.gov.in/upyog-ui/citizen/mcollect-home';

      context.pushWidget(WebDashboardPage(webUrl:webUrl,token: token, userData: userData));
    },
  ),
  Service(
    "Trade\nLicense",
    "assets/images/trade_lic.png",
    onTap: (context) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coming soon'),
        ),
      );
    },
  ),

  Service(
    "Hoarding\nPermission",
    "assets/images/hoarding_per.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
      ),
    );},
  ),

  Service(
    "Tree Cutting\nPermission",
    "assets/images/tree.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
      ),
    );},
  ),

  Service(
    "NOC\nIssuance",
    "assets/images/noc.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
      ),
    );},
  ),

  Service(
    "Water &\nSewerage\nConnection",
    "assets/images/home.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
      ),
    );},
  ),

  Service(
    "Birth & Death Registration",
    "assets/images/p_women.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
      ),
    );},
  ),

  Service(
    "Health Facility Registration",
    "assets/images/hospital.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
      ),
    );},
  ),

  Service(
    "Property\nTax",
    "assets/images/property_tax.png",
    onTap: (context) {
      openUrl( "https://propertytax.nmctax.in/");
      },
  ),
];

List<Service> civicServices = [
  Service(
    "Civic\nServices",
    "assets/images/family.png",
    onTap: (context) {
      openUrl('https://civicservices.nmc.gov.in/login');
      },
  ),

  Service("NMC\nNEWS", "assets/images/news.png",  onTap: (context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
      ),
    );},),

  Service("FAQ", "assets/images/faq.png",   onTap: (context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
      ),
    );},),

  Service(
    "NMC\nHelp Centre",
    "assets/images/help.png",
    onTap: (context) {
      callFunction(context);
    },
  ),

  Service(
    "Know our\nWorks",
    "assets/images/work.png",
      onTap: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coming soon'),
          ),
        );},
  ),

  Service(
    "Elected\nMembers",
    "assets/images/election.png",
    onTap: (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coming soon'),
        ),
      );},
  ),

  Service("Administration", "assets/images/admin.png",   onTap: (context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
      ),
    );},),

  Service(
    "Important\nContacts",
    "assets/images/add_call.png",
    onTap: (context) {
      openUrl('https://nmc.gov.in/home/getfrontpage/7/191/E#tabs|History:tab1');

    },
  ),
];


callFunction(
    BuildContext context,

    ) {
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
              title: const Text('NMC help center(Available from 7AM to 11PM)'),
              subtitle: Text("7030300300"),
              onTap: () =>  makePhoneCall("7030300300"),

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
  final Uri uri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

