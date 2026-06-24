import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nmc_wrapper/models/helplineModel/emergency_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contact;

  const ContactTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        contact.name ?? '',
        style: GoogleFonts.notoSans(fontSize: 15),
      ),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: contact.phoneNumbers!.map((phone) {
          return Row(
            children: [
              Expanded(
                child: Text(phone, style: GoogleFonts.notoSans(fontSize: 15)),
              ),

              IconButton(
                icon: const Icon(Icons.call, color: Colors.green),

                onPressed: () {
                  makePhoneCall(phone);
                  // launchUrlString(
                  // "tel:$phone");
                },
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
