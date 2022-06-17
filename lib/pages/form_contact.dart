import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobcontact/databases/db_helper.dart';
import 'package:mobcontact/models/contact_model.dart';
import 'package:mobcontact/pages/list_contact.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FormContact extends StatefulWidget {
  final Contact contact;
  FormContact(this.contact, {Key? key}) : super(key: key);
  @override
  State<FormContact> createState() => _FormContactState();
}

class _FormContactState extends State<FormContact> {
  final DbHelper dbHelper = DbHelper();
  File? imageFile;
  final txtNama = TextEditingController();
  final txtTelp = TextEditingController();
  final txtEmail = TextEditingController();
  final txtCompany = TextEditingController();
  final txtPhoto = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      txtNama.text = widget.contact.name ?? "";
      txtTelp.text = widget.contact.mobileNo ?? "";
      txtEmail.text = widget.contact.email ?? "";
      txtCompany.text = widget.contact.company ?? "";
    }
  }

  Future<String> appPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  getFromGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    appPath().then((value) {
      String appPath = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // ignore: unnecessary_null_comparison
          title: widget.contact.id != null
              ? const Text("Update Contact")
              : const Text("Add Contact")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.name,
                controller: txtNama,
                decoration: const InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.phone,
                controller: txtTelp,
                decoration: const InputDecoration(
                    labelText: "Nomor HP",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone)),
              ),
              const SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.streetAddress,
                controller: txtCompany,
                decoration: const InputDecoration(
                    labelText: "Nama Perusahaan",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home)),
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: txtPhoto,
                  decoration: InputDecoration(
                    labelText: "Photo",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.photo),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.photo_camera),
                        onPressed: () async {
                          await getFromGallery();
                          print("pick image");
                        }),
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () async {
                    Contact data = Contact(
                        name: txtNama.text,
                        mobileNo: txtTelp.text,
                        email: txtEmail.text,
                        company: txtCompany.text,
                        photo: txtPhoto.text);
                    if (widget.contact.id != null) {
                      data.id = widget.contact.id;
                      await dbHelper.update(data);
                    } else {
                      await dbHelper.save(data);
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListContact()));
                  },
                  child: widget.contact.id != null
                      ? const Text("Update Contact")
                      : const Text("Save Contact"))
            ],
          ),
        ),
      ),
    );
  }
}
