// import 'package:dice_app/database_helper.dart';
import 'package:safe_sprout/database_helper.dart';
import 'package:safe_sprout/modules/Contacts/add_contacts.dart';
import 'package:safe_sprout/modules/Contacts/model/contactsm.dart';
import 'package:safe_sprout/modules/Emagazine/e_magazine.dart';
import 'package:safe_sprout/modules/FriendLocator.dart';
import 'package:safe_sprout/modules/SOS/bg_sms.dart';
import 'package:safe_sprout/modules/SurvivorStories/survivor.dart';
import 'package:safe_sprout/modules/Custom/CustomCarouel.dart';
import 'package:safe_sprout/modules/Emergencies/Emergency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Safe Sprout",
        ),
        titleTextStyle: GoogleFonts.comfortaa(
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 251, 243, 245),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 251, 243, 245),
          // color: Color.fromARGB(25, 51, 51, 51),
          padding: const EdgeInsets.only(left: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Emergency",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Emergency(),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    List<TContact> contactList =
                        await DatabaseHelper().getContactList();
                    print(contactList.length);
                    if (contactList.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Emergency contact list is empty");
                    } else {
                      try {
                        // Check if location service is enabled
                        if (!await Geolocator.isLocationServiceEnabled()) {
                          throw 'Location service disabled';
                        }

                        // Request location permission
                        LocationPermission permission =
                            await Geolocator.checkPermission();
                        if (permission == LocationPermission.denied ||
                            permission == LocationPermission.deniedForever) {
                          permission = await Geolocator.requestPermission();
                          if (permission == LocationPermission.denied ||
                              permission == LocationPermission.deniedForever) {
                            throw 'Location permission denied';
                          }
                        }

                        // Get current location
                        Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high,
                        );

                        double latitude = position.latitude;
                        double longitude = position.longitude;

                        // Construct Google Maps link
                        String googleMapsLink =
                            'https://www.google.com/maps?q=$latitude,$longitude';

                        // Construct SMS message with location
                        String messageBody =
                            'Need help! Please track me here: $googleMapsLink';

                        // Send SMS to each contact
                        for (TContact contact in contactList) {
                          String phoneNumber = contact.number;
                          await SmsService.sendSmsWithLocation(
                            phoneNumber,
                            messageBody,
                          );
                          print("SMS sent successfully to $phoneNumber");
                        }
                      } catch (error) {
                        print("Error sending SOS: $error");
                        Fluttertoast.showToast(
                          msg: "Failed to send SOS message: $error",
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    textStyle: const TextStyle(color: Colors.white),
                    backgroundColor: Color.fromARGB(255, 218, 108, 108),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 100),
                  ),
                  child: const Text(
                    'SOS',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Inspiring Articles",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomCarouel(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 251, 243, 245),
        items: [
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Image.asset(
                  "assets/images/news.png",
                  height: 36,
                ),
                const Text("EMagazine"),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Image.asset(
                  "assets/images/call.png",
                  height: 36,
                ),
                const Text("Contacts"),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Image.asset(
                  "assets/images/location.png",
                  height: 36,
                ),
                const Text("Live\nSafe"),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Image.asset(
                  "assets/images/stories.png",
                  height: 36,
                ),
                const Text("Survivor \n Stories"),
              ],
            ),
            label: '',
          ),
        ],
        onTap: (index) {
          HapticFeedback.mediumImpact();
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EMagazine()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddContacts()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendLocator()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SurvivorStory()),
              );
              break;
          }
        },
      ),
    );
  }
}
