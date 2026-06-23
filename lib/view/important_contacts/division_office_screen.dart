import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nmc_wrapper/models/helplineModel/emergency_contacts.dart';
import 'package:nmc_wrapper/view/important_contacts/office_card.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  State<EmergencyContactScreen> createState() =>
      _EmergencyContactScreenState();
}

class _EmergencyContactScreenState
    extends State<EmergencyContactScreen> {

  List<ContactCategory> allContacts = [];
  List<ContactCategory> filtered = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {

    allContacts = await loadContacts();

    filtered = allContacts;

    setState(() {});
  }


  Future<List<ContactCategory>> loadContacts() async {

    final jsonString = await rootBundle.loadString(
        'assets/json/emergency_contacts.json');

    final jsonData = json.decode(jsonString);

    final response =
    EmergencyContactsResponse.fromJson(jsonData);

    return response.categories ?? [];
  }

  void search(String text) {

    if(text.isEmpty){

      filtered = allContacts;
    }

    else{

      filtered = allContacts.where((e){

        return e.name!
            .toLowerCase()
            .contains(text.toLowerCase());

      }).toList();
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Emergency Contacts"),
      ),

      body: Column(

        children: [

          Padding(

            padding: const EdgeInsets.all(10),

            child: TextField(

              onChanged: search,

              decoration: InputDecoration(

                hintText: "Search",

                prefixIcon: Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          Expanded(

            child: ListView.builder(

              itemCount: filtered.length,

              itemBuilder: (context,index){

                final item = filtered[index];

                return ContactCategoryWidget(
                    category: item);
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

  const ContactCategoryWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.all(8),

      child: ExpansionTile(

        title: Text(

          category.name ?? '',

          style: const TextStyle(

            fontWeight: FontWeight.bold,
          ),
        ),

        children:

        category.contacts!.map((contact){

          return ContactTile(
              contact: contact);

        }).toList(),
      ),
    );
  }
}

