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
      titleKey: "divisionalOffices",
      icon: Icons.phone_in_talk,
      color: Colors.blue,
    ),
    HelplineModel(
      titleKey: "amardham",
      icon: Icons.phone_in_talk,
      color: Colors.indigo,
    ),
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
      titleKey: "maternityHome",
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
      titleKey: "pathologyLab",
      icon: Icons.phone_in_talk,
      color: Colors.lightBlue,
    ),
    HelplineModel(
      titleKey: "medicalCollege",
      icon: Icons.phone_in_talk,
      color: Colors.indigo,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECEFF3),

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
        title: Text(AppStrings.translate(context, "important_contacts"),
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
                context.pushWidget(EmergencyContactScreen());
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
      height: 58,
      width: 58,

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

      child: Icon(item.icon, color: Colors.white, size: 28),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      AppStrings.translate(context, item.titleKey),

      textAlign: TextAlign.center,

      maxLines: 2,

      overflow: TextOverflow.ellipsis,

      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xff1D4370),
      ),
    );
  }
}
