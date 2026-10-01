// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:intl/intl.dart';
import 'dart:async'; // Auto-slider ke liye

class NamazTimingsList extends StatefulWidget {
  const NamazTimingsList({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _NamazTimingsListState createState() => _NamazTimingsListState();
}

class _NamazTimingsListState extends State<NamazTimingsList> {
  late Future<List<dynamic>> _mosquesFuture;
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  // Login status variables
  bool _isLoggedIn = false;
  String _userEmail = '';

  // --- AUTO SLIDER VARIABLES ---
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _sliderTimer;
  List<String> _dynamicSliderImages = [];
  bool _isSliderLoading = true;

  // Default photo agar Supabase table khali ho ya abhi tak na bani ho
  final String _defaultImage =
      'https://images.unsplash.com/photo-1590076215667-874d4df30870?auto=format&fit=crop&w=800&q=80';

  @override
  void initState() {
    super.initState();
    _mosquesFuture =
        SupaFlow.client.from('mosques').select().order('name', ascending: true);
    _checkAuthStatus();
    _fetchSliderImages();
  }

  // Supabase se photos fetch karne ka logic
  void _fetchSliderImages() async {
    try {
      final response =
          await SupaFlow.client.from('slider_photos').select('photo_url');
      if (response != null && response is List && response.isNotEmpty) {
        if (mounted) {
          setState(() {
            _dynamicSliderImages = response
                .map<String>((row) => row['photo_url'].toString())
                .toList();
            _isSliderLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isSliderLoading = false);
      }
    } catch (e) {
      print("Slider photos table not found or error: $e");
      if (mounted) setState(() => _isSliderLoading = false);
    }

    // Auto-slide Timer
    _sliderTimer =
        Timer.periodic(const Duration(milliseconds: 2500), (Timer timer) {
      final int imageCount =
          _dynamicSliderImages.isEmpty ? 1 : _dynamicSliderImages.length;
      if (_pageController.hasClients && imageCount > 1) {
        if (_currentPage < imageCount - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _checkAuthStatus() {
    final user = SupaFlow.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _isLoggedIn = true;
        _userEmail = user.email ?? '';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: const Color(0xFF09090B),
      child: Stack(
        children: [
          // --- YAHAN CHANGE KIYA HAI: SingleChildScrollView lagaya hai taaki sab ek sath scroll ho ---
          SingleChildScrollView(
            child: Column(
              children: [
                // --- NEON SEARCH BAR & MENU SHURU ---
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 10.0, right: 20.0, bottom: 10.0),
                  child: Row(
                    children: [
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.menu,
                            color: Colors.cyanAccent, size: 30),
                        color: const Color(0xFF12121A),
                        offset: const Offset(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              color: Colors.cyanAccent.withOpacity(0.5)),
                        ),
                        onSelected: (value) async {
                          if (value == 'login') {
                            context.pushNamed('LoginPage');
                          } else if (value == 'logout') {
                            await SupaFlow.client.auth.signOut();
                            setState(() {
                              _isLoggedIn = false;
                              _userEmail = '';
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          if (!_isLoggedIn)
                            const PopupMenuItem(
                              value: 'login',
                              child: Row(
                                children: [
                                  Icon(Icons.login,
                                      color: Colors.cyanAccent, size: 20),
                                  SizedBox(width: 10),
                                  Text('Admin Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins')),
                                ],
                              ),
                            ),
                          if (_isLoggedIn)
                            const PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout,
                                      color: Colors.redAccent, size: 20),
                                  SizedBox(width: 10),
                                  Text('Logout',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontFamily: 'Poppins')),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                          style: const TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF12121A),
                            hintText: 'Masjid search karein...',
                            hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white54,
                                fontSize: 14),
                            prefixIcon: const Icon(Icons.search,
                                color: Colors.cyanAccent),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.pinkAccent),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Colors.cyanAccent.withOpacity(0.5),
                                  width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Colors.cyanAccent, width: 2),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // --- NEON SEARCH BAR & MENU KHATAM ---

                // --- DYNAMIC IMAGE SLIDER SHURU ---
                Container(
                  height: 180,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12121A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.6), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        if (_isSliderLoading)
                          const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.cyanAccent))
                        else
                          PageView.builder(
                            controller: _pageController,
                            itemCount: _dynamicSliderImages.isEmpty
                                ? 1
                                : _dynamicSliderImages.length,
                            onPageChanged: (index) {
                              _currentPage = index;
                            },
                            itemBuilder: (context, index) {
                              final imgUrl = _dynamicSliderImages.isEmpty
                                  ? _defaultImage
                                  : _dynamicSliderImages[index];
                              return Image.network(
                                imgUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'NAMAZ TIMINGS RAMPUR',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 2.5,
                              shadows: [
                                Shadow(
                                  color: Colors.cyanAccent.withOpacity(0.9),
                                  blurRadius: 20,
                                ),
                                const Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_userEmail == 'udanish427@gmail.com')
                          Positioned(
                            top: 10,
                            right: 10,
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Super Admin Menu khul raha hai...',
                                        style:
                                            TextStyle(fontFamily: 'Poppins')),
                                    backgroundColor: Color(0xFF6B4EE6),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                context.pushNamed('SuperAdminPage');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.cyanAccent, width: 1),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.upload,
                                        color: Colors.cyanAccent, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Upload Photos',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.cyanAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // --- DYNAMIC IMAGE SLIDER KHATAM ---

                // --- MASJID KI LIST ---
                // Yahan se 'Expanded' hata diya hai taaki scroll sahi kaam kare
                FutureBuilder<List<dynamic>>(
                    future: _mosquesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: CircularProgressIndicator(
                              color: Colors.cyanAccent),
                        ));
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Text('Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.redAccent)),
                        ));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Text('Data nahi mila.',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  color: Colors.white70)),
                        ));
                      }

                      final allMosques = snapshot.data!;
                      final filteredMosques = allMosques.where((masjid) {
                        final name =
                            (masjid['name'] ?? '').toString().toLowerCase();
                        final area =
                            (masjid['area'] ?? '').toString().toLowerCase();
                        return name.contains(_searchQuery) ||
                            area.contains(_searchQuery);
                      }).toList();

                      if (filteredMosques.isEmpty) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Text('Koi masjid nahi mili.',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  color: Colors.white70)),
                        ));
                      }

                      return ListView.builder(
                        shrinkWrap:
                            true, // <-- NAYA: Isse list apni height khud adjust karegi
                        physics:
                            const NeverScrollableScrollPhysics(), // <-- NAYA: Isse list apne aap scroll na hokar main page ke sath scroll hogi
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 100),
                        itemCount: filteredMosques.length,
                        itemBuilder: (context, index) {
                          final masjid = filteredMosques[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF12121A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.cyanAccent.withOpacity(0.8),
                                  width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyanAccent.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              masjid['name'] ??
                                                  'Unknown Masjid',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.cyanAccent,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.cyanAccent,
                                                      blurRadius: 12),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              masjid['area'] ?? 'Rampur City',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  color: Colors.white60,
                                                  letterSpacing: 1.2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showMasjidDetails(
                                            context,
                                            masjid['name']?.toString(),
                                            masjid['address']?.toString(),
                                            masjid['phone_number']?.toString(),
                                            masjid['mutawalli_name']
                                                ?.toString(),
                                            masjid['imamName']?.toString(),
                                            masjid['google_maps_link']
                                                ?.toString(),
                                            (masjid['photos'] as List?)
                                                ?.map((e) => e.toString())
                                                .toList(),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.cyanAccent
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.cyanAccent
                                                    .withOpacity(0.6),
                                                width: 1),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.info_outline,
                                                  color: Colors.cyanAccent,
                                                  size: 18),
                                              SizedBox(width: 4),
                                              Text(
                                                'Masjid Details',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.cyanAccent,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                      height: 30,
                                      color: Colors.cyanAccent.withOpacity(0.3),
                                      thickness: 1),
                                  _buildTimeRow('Fajr', masjid['fajr'],
                                      Colors.yellowAccent),
                                  _buildTimeRow('Dhuhr (Zuhar)',
                                      masjid['dhuhr'], Colors.yellowAccent),
                                  _buildTimeRow('Asr', masjid['asr'],
                                      Colors.yellowAccent),
                                  _buildTimeRow('Maghrib', masjid['maghrib'],
                                      Colors.yellowAccent),
                                  _buildTimeRow('Isha', masjid['isha'],
                                      Colors.yellowAccent),
                                  Divider(
                                      height: 24,
                                      color: Colors.cyanAccent.withOpacity(0.3),
                                      thickness: 1),
                                  _buildTimeRow('Jummah', masjid['jummah'],
                                      Colors.greenAccent,
                                      isJummah: true),
                                  const SizedBox(height: 15),
                                  Builder(
                                    builder: (context) {
                                      String dateText = "";
                                      final timeString =
                                          masjid['last_updated']?.toString();
                                      if (timeString != null &&
                                          timeString.isNotEmpty) {
                                        try {
                                          final DateTime dt =
                                              DateTime.parse(timeString)
                                                  .toLocal();
                                          dateText = DateFormat(
                                                  'dd-MM-yyyy hh:mm:ss a')
                                              .format(dt)
                                              .toLowerCase();
                                        } catch (e) {
                                          dateText = "N/A";
                                        }
                                      }
                                      return Center(
                                        child: Text(
                                          'Last Updated: $dateText',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10,
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ],
            ),
          ),

          // --- NEON GLOWING EDIT BUTTON ---
          if (_isLoggedIn)
            Positioned(
              bottom: 30,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  if (_userEmail == 'udanish427@gmail.com') {
                    context.pushNamed('SuperAdminPage');
                  } else {
                    context.pushNamed('EditTimePage');
                  }
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF12121A),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.cyanAccent,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        blurRadius: 15,
                        spreadRadius: 3,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.cyanAccent,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String name, dynamic time, Color neonColor,
      {bool isJummah = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
          ),
          Text(
            time?.toString() ?? '--:--',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: neonColor,
              shadows: [
                Shadow(color: neonColor.withOpacity(0.9), blurRadius: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
