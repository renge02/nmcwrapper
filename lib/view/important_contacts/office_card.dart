import 'package:flutter/material.dart';
import 'package:nmc_wrapper/models/helplineModel/emergency_contacts.dart';

class ContactTile extends StatelessWidget {

  final ContactModel contact;

  const ContactTile({
    super.key,
    required this.contact,
  });


  @override

  Widget build(BuildContext context) {

    return ListTile(

      title: Text(contact.name ?? ''),

      subtitle: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children:

        contact.phoneNumbers!.map((phone){

          return Row(

            children: [

              Expanded(
                child: Text(phone),
              ),

              IconButton(

                icon: const Icon(
                    Icons.call,
                    color: Colors.green),

                onPressed: () {

                  // launchUrlString(
                  // "tel:$phone");

                },
              )
            ],
          );

        }).toList(),
      ),
    );
  }
}