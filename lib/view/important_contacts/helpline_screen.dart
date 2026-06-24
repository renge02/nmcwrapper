import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/models/helplineModel/helpline_model.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/view/important_contacts/division_office_screen.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';

class HelplineScreen extends StatelessWidget {
  HelplineScreen({super.key});

  List<HelplineModel> helplineList = [
    HelplineModel(
      titleKey: "fireBrigade",
      icon: Icons.phone_in_talk,
      color: Colors.deepPurple,
    ),
    HelplineModel(
      titleKey: "waterSupply",
      icon: Icons.phone_in_talk,
      color: Colors.pink,
    ),
    HelplineModel(
      titleKey: "ambulance",
      icon: Icons.phone_in_talk,
      color: Colors.pinkAccent,
    ),
    HelplineModel(
      titleKey: "policeStation",
      icon: Icons.phone_in_talk,
      color: Colors.deepOrange,
    ),
    HelplineModel(
      titleKey: "hospital",
      icon: Icons.phone_in_talk,
      color: Colors.orange,
    ),
    HelplineModel(
      titleKey: "bloodBank",
      icon: Icons.phone_in_talk,
      color: Colors.amber,
    ),
    HelplineModel(
      titleKey: "theatres",
      icon: Icons.phone_in_talk,
      color: Colors.lightBlue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9E8),

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),

          onPressed: () {
            context.pop();
          },
        ),
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: AppTheme.appBarColor,
        title: Text(
          AppStrings.translate(context, "important_contacts"),
          style: GoogleFonts.notoSans(fontSize: 14, color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: GridView.builder(
          itemCount: helplineList.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),

          itemBuilder: (context, index) {
            return HelplineItem(
              item: helplineList[index],
              onTap: () {
                print(helplineList[index].titleKey);
                context.pushWidget(
                  EmergencyContactScreen(
                    categoryName: AppStrings.translate(
                      context,
                      helplineList[index].titleKey,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class HelplineItem extends StatelessWidget {
  final HelplineModel item;
  final VoidCallback onTap;

  const HelplineItem({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              _buildIcon(),

              const SizedBox(height: 16),

              _buildTitle(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      height: 48,
      width: 48,

      decoration: BoxDecoration(
        color: item.color,
        shape: BoxShape.circle,

        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(.30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Icon(item.icon, color: Colors.white, size: 25),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      AppStrings.translate(context, item.titleKey),

      textAlign: TextAlign.center,

      maxLines: 2,

      overflow: TextOverflow.ellipsis,

      style: GoogleFonts.notoSans(fontSize: 15, color: Color(0xff1D4370)),
    );
  }
}
