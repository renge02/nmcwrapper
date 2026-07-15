import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/electedModel/elected_model.dart';

class RepresentativeDetailsScreen extends StatelessWidget {
  final Category category;
  final int index;

  const RepresentativeDetailsScreen({
    super.key,
    required this.category, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isMarathi =
        Localizations.localeOf(context).languageCode == "mr";

    final details = category.details!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),

          onPressed: () {
            context.pop();
          },
        ),

        title: Text(
          isMarathi
              ? category.title?.mr ?? ""
              : category.title?.en ?? "",
          style: GoogleFonts.notoSans(fontSize: 14, color: Colors.white),

        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// Photo

            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    index == 0
                        ? "assets/images/Mayor_NMC.jpg"
                        : index == 1
                        ? "assets/images/Deputy_Mayor.jpg"
                        : "assets/images/Chairman.png",
                  ),
                  fit: BoxFit.cover,
                ),
                // color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 5),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Name Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff8A99B8),
                    Color(0xff7085AA),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  isMarathi
                      ? details.name?.mr ?? ""
                      : details.name?.en ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      _buildRow(
                          AppStrings.translate(
                              context,
                              'party'
                          ),
                        isMarathi
                            ? details.party?.mr ?? ""
                            : details.party?.en ?? "",
                      ),

                      const SizedBox(height: 15),

                      _buildRow(
                        AppStrings.translate(
                            context,
                            'ward_number'
                        ),
                        details.wardNumber ?? "",
                      ),

                      const SizedBox(height: 15),

                      /// Mobile
                      Row(
                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  AppStrings.translate(
                                      context,
                                      'mobile'
                                  ),
                                  style: GoogleFonts.notoSans(
                                    color: AppTheme.appBarColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  details.mobileNumber ?? "",
                                  style: GoogleFonts.notoSans(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.green,
                            child: IconButton(
                              icon: const Icon(
                                Icons.call,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                launchUrl(
                                  Uri.parse(
                                    "tel:${details.mobileNumber}",
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.translate(
                              context,
                              'address'
                          ),
                          style: GoogleFonts.notoSans(
                            color: AppTheme.appBarColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isMarathi
                              ? details.address?.mr ?? ""
                              : details.address?.en ?? "",
                          style: GoogleFonts.notoSans(
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          width: 110,
          child: Text(
            title,
            style: GoogleFonts.notoSans(
              color: AppTheme.appBarColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: Text(
            value,
            style: GoogleFonts.notoSans(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}