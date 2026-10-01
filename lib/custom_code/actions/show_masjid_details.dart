// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<void> showMasjidDetails(
  BuildContext context,
  String? masjidName,
  String? address,
  String? phone,
  String? mutawalli,
  String? imamName, // NAYA PARAMETER
  String? mapLink,
  List<String>? photos,
) async {
  // Popup (Bottom Sheet) ka UI
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: const Color(0xFF12121A), // Dark Glass Theme
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          border:
              Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          children: [
            // Upar ka chhota sa Drag Handle
            const SizedBox(height: 10),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            // Photos Swipe wala (PageView)
            if (photos != null && photos.isNotEmpty)
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          photos[index],
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => Container(
                            color: Colors.black26,
                            child: const Icon(Icons.broken_image,
                                color: Colors.white54, size: 50),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              // Agar photo na ho toh ek default icon dikhega
              Container(
                height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Center(
                  child: Icon(Icons.mosque, color: Colors.cyanAccent, size: 60),
                ),
              ),

            const SizedBox(height: 20),

            // Niche ki Details List
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Masjid ka Naam
                    Text(
                      masjidName ?? 'Unknown Masjid',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.0,
                        shadows: [
                          Shadow(color: Colors.cyanAccent, blurRadius: 10)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Address
                    _infoRow(
                        Icons.location_on,
                        'Address',
                        address ?? 'Address available nahi hai',
                        Colors.cyanAccent),
                    const Divider(color: Colors.white12, height: 30),

                    // Imam Name
                    _infoRow(
                        Icons.person_pin,
                        'Imam Name',
                        imamName ?? 'Naam available nahi hai',
                        Colors.orangeAccent),
                    const SizedBox(height: 20),

                    // Mutawalli & Phone ka Combined Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161622).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.cyanAccent.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _infoRow(
                              Icons.person,
                              'Mutawalli Name',
                              mutawalli ?? 'Naam available nahi hai',
                              Colors.yellowAccent),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: Colors.white12, height: 1),
                          ),
                          _infoRow(
                              Icons.phone,
                              'Phone Number',
                              phone ?? 'Number available nahi hai',
                              Colors.greenAccent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Call aur Maps wale Buttons
                    Row(
                      children: [
                        if (phone != null && phone.isNotEmpty)
                          Expanded(
                            child: ElevatedButton.icon(
                              // Yahan humne FlutterFlow ka built-in launchURL use kiya hai
                              onPressed: () async =>
                                  await launchURL('tel:$phone'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              icon: const Icon(Icons.call, color: Colors.black),
                              label: const Text('CALL',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        if (phone != null && phone.isNotEmpty)
                          const SizedBox(width: 15),
                        if (mapLink != null && mapLink.isNotEmpty)
                          Expanded(
                            child: ElevatedButton.icon(
                              // Yahan bhi FlutterFlow ka built-in launchURL use kiya hai
                              onPressed: () async => await launchURL(mapLink),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyanAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              icon: const Icon(Icons.map, color: Colors.black),
                              label: const Text('MAPS',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Chhoti si styling setting
Widget _infoRow(IconData icon, String title, String value, Color iconColor) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: iconColor, size: 28),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.white54)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ],
  );
}
