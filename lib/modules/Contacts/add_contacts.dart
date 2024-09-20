import 'package:safe_sprout/database_helper.dart';
import 'package:safe_sprout/modules/Contacts/contacts.dart';
import 'package:safe_sprout/modules/Contacts/model/contactsm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({super.key});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<TContact>? contactList;
  int count = 0;
  void showList() {
    Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture =
          _databaseHelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          contactList = value;
          count = value.length;
        });
      });
    });
  }

  void deleteContact(TContact contact) async {
    int result = await _databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "contact removed successfully");
      showList();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showList();
    });
    super.initState();
  }

// @override
//   void initState() {
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       showList();
//     });
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    contactList ??= [];
    return SafeArea(
      child: Container(
        color: const Color.fromARGB(255, 251, 243, 245),
        // color: const Color.fromARGB(255, 248, 245, 252),
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 215, 202, 232)),
              onPressed: () async {
                HapticFeedback.mediumImpact();
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (context) => Contacts()),
                );
                if (result != null && result) {
                  showList();
                }
              },
              child: const Text(
                "Add Trusted Contacts",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(contactList![index].name),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();
                                  await FlutterPhoneDirectCaller.callNumber(
                                      contactList![index].number);
                                },
                                icon: const Icon(Icons.call),
                                color: Colors.red[600],
                              ),
                              IconButton(
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();
                                  deleteContact(contactList![index]);
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.red[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
