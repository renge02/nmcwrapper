import 'package:flutter/material.dart';
import 'package:nmc_wrapper/models/serviceModel/service.item.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_alert.dart';
import 'package:nmc_wrapper/view/webview/webview.dart';
import 'package:nmc_wrapper/view/webview/webview_Page.dart';
import 'package:provider/provider.dart';

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

  final List<ServiceItem> services = [
    ServiceItem(
      image: "assets/images/grienvance_redressal.png",
      title: "Grievance Redressal",
      onTap: (context) async {
     String   token = await getIt<SecureStorage>().getToken() ?? '';
     String   userData = await getIt<SecureStorage>().getUserData() ?? '';

        context.pushWidget(WebDashboardPage(token: token, userData: userData,));

      },
    ),
    ServiceItem(
      image: "assets/images/marriage_registration.png",
      title: "Marriage Registration",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/trade_lic.png",
      title: "Trade License",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/hoarding.png",
      title: "Hoarding Permission",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/tree_cutting.png",
      title: "Tree Cutting Permission",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/noc_insurance.png",
      title: "NOC Issuance",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/water_tap.png",
      title: "Water & Sewerage Connection",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/birth_death_cert.png",
      title: "Birth & Death Registration",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/accounting.png",
      title: "Accounting & Finance",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/rupee.png",
      title: "Miscellaneous Collections",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/hospital.png",
      title: "Health Facility Registration",
      onTap: (context) {},
    ),
    ServiceItem(
      image: "assets/images/property_tax.png",
      title: "Property Tax",
      onTap: (context) {},
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F5F7),

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
            icon: const Icon(
              Icons.language,
              color: Colors.white,
            ),
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const PopupMenuItem<String>(
                value: "mr",
                child: Text(
                  "मराठी",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
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

      /// BODY
      body: Padding(
        padding: const EdgeInsets.all(12),
        child:
        GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final item = services[index];

            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => item.onTap(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: index == 0
                        ? const Color(0xFF8D2323)
                        : Colors.grey.shade300,
                    width: index == 0 ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Opacity(
                            opacity: index == 0 ? 1.0 : 0.5,
                            child: Image.asset(
                              item.image,
                               width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )      ),    );
  }

  Widget drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: Colors.black87, size: 24),
          title: Text(
            title,
            style: context.bodyMedium()?.textColor(Colors.black).size(16),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.black87),
        ),
      ),
    );
  }
}
