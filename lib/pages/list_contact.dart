import 'package:flutter/material.dart';
import 'package:mobcontact/databases/db_helper.dart';
import 'package:mobcontact/models/contact_model.dart';
import 'package:mobcontact/pages/form_contact.dart';

class ListContact extends StatefulWidget {
  const ListContact({Key? key}) : super(key: key);
  @override
  State<ListContact> createState() => _ListContactState();
}

class _ListContactState extends State<ListContact> {
  final List<Contact> listContact = [];
  final DbHelper dbHelper = DbHelper();
  Future<List<Contact>> getAllContact() async {
    listContact.clear();
    await dbHelper.getListContact().then((value) {
      (value as List).forEach((json) {
        listContact.add(Contact.fromJson(json));
      });
    });
    return listContact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Contacts")),
      body: FutureBuilder<List<Contact>>(
        future: getAllContact(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>>snapshot) {
          if (snapshot.hasData) {
            List<Contact> contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return ListTile(
                  leading: const CircleAvatar(
                    radius: 25,backgroundColor: Colors.amber,
                  ),
                  title: Text("${contact.name}"),
                  subtitle: Text("${contact.email}, ${contact.mobileNo}"),
                  trailing: FittedBox(
                    fit: BoxFit.fill,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await dbHelper.delete(contact.id!);
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete)
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormContact(contact)
                              )
                            );
                          },
                          icon: const Icon(Icons.edit)
                        ),
                      ],
                    )
                  )
                );
              }
            );
          } else {
            return const Center(
              child: Text("Belum ada data"),
            );
          }
        }
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: "add contact",
            onPressed: () {
              Navigator.push(
              context,MaterialPageRoute(
                builder: (context) => FormContact(Contact())
              ));
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () async {
              getAllContact();
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}