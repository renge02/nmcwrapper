import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';

import '../../models/electedModel/elected_model.dart';
import 'elected_details_screen.dart';

class ElectedRepresentativeScreen extends StatefulWidget {
  final List<Category> categories;

  const ElectedRepresentativeScreen({super.key, required this.categories});

  @override
  State<ElectedRepresentativeScreen> createState() =>
      _ElectedRepresentativeScreenState();
}

class _ElectedRepresentativeScreenState
    extends State<ElectedRepresentativeScreen> {
  final List<Color> colors = const [
    Color(0xFF6A4C93),
    Color(0xFF20C5B5),
    Color(0xFF2196F3),
    Color(0xFFFF7043),
    Color(0xFF26A69A),
    Color(0xFF5C6BC0),
  ];

  ElectedRepresentativeResponse? response;
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<ElectedRepresentativeResponse> loadRepresentatives() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/elected_contacts.json',
    );

    final jsonData = json.decode(jsonString);

    return ElectedRepresentativeResponse.fromJson(jsonData);
  }

  Future<void> loadData() async {
    response = await loadRepresentatives();

    categories = response?.categories ?? [];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isMarathi = Localizations.localeOf(context).languageCode == "mr";

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        backgroundColor: AppTheme.appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),

          onPressed: () {
            context.pop();
          },
        ),

        title: Text(
          isMarathi ? "लोकप्रतिनिधी" : "Elected Representatives",
          style: GoogleFonts.notoSans(fontSize: 14, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: .72,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];

            return RepresentativeCard(
              category: item,
              color: colors[index % colors.length],
              isMarathi: isMarathi,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class RepresentativeCard extends StatelessWidget {
  final Category category;
  final int index;
  final Color color;
  final bool isMarathi;

  const RepresentativeCard({
    super.key,
    required this.category,
    required this.color,
    required this.isMarathi,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        context.pushWidget(
          RepresentativeDetailsScreen(category: category, index: index),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 25),

            Container(
              height: 90,
              width: 90,
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

            const Spacer(),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                isMarathi ? category.title!.mr! : category.title!.en!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
