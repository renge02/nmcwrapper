import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/models/helplineModel/emergency_contacts.dart';
import 'package:nmc_wrapper/utils/app_strings.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/view/important_contacts/office_card.dart';
import 'package:nmc_wrapper/view/shared/app.theme.dart';

class EmergencyContactScreen extends StatefulWidget {
  final String? categoryName;

  const EmergencyContactScreen({super.key, this.categoryName});

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  List<ContactCategory> allContacts = [];
  List<ContactCategory> filtered = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    allContacts = await loadContacts();

    if (widget.categoryName != null) {
      print("categoryname... ${widget.categoryName}");
      filtered = allContacts
          .where((e) => e.name == widget.categoryName)
          .toList();
    } else {
      filtered = allContacts;
    }

    setState(() {});
  }

  Future<List<ContactCategory>> loadContacts() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/emergency_contacts.json',
    );

    final jsonData = json.decode(jsonString);

    final response = EmergencyContactsResponse.fromJson(jsonData);

    return response.categories ?? [];
  }

  void search(String text) {
    final query = text.trim().toLowerCase();

    if (query.isEmpty) {
      filtered = allContacts
          .where((e) => e.name == widget.categoryName)
          .toList();
    } else {
      ContactCategory? matchedCategory;

      for (final category in filtered) {

        final categoryMatch =
        (category.name ?? '').toLowerCase().contains(query);

        final matchedContacts = category.contacts?.where((contact) {
          final nameMatch =
          (contact.name ?? '').toLowerCase().contains(query);

          final phoneMatch =
              contact.phoneNumbers?.any(
                    (phone) => phone.contains(query),
              ) ??
                  false;

          return nameMatch || phoneMatch;
        }).toList();

        if (categoryMatch || (matchedContacts?.isNotEmpty ?? false)) {
          matchedCategory = ContactCategory(
            name: category.name,
            contacts: categoryMatch
                ? category.contacts
                : matchedContacts,
          );
          break; // Stops after finding the first matching category
        }
      }

      filtered = matchedCategory != null ? [matchedCategory] : [];
    }

    setState(() {});
  }
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
          AppStrings.translate(context, "emergency_contacts"),
          style: GoogleFonts.notoSans(fontSize: 14, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: search,
              style: GoogleFonts.notoSans(fontSize: 16),
              decoration: InputDecoration(
                hintText: AppStrings.translate(context, 'search'),
                hintStyle: GoogleFonts.notoSans(fontSize: 14, ),

                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,

              itemBuilder: (context, index) {
                final item = filtered[index];

                return ContactCategoryWidget(category: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContactCategoryWidget extends StatelessWidget {
  final ContactCategory category;

  const ContactCategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: category.contacts?.length ?? 0,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return ContactTile(contact: category.contacts![index]);
      },
    );
  }
}
