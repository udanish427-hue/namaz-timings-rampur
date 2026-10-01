// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class NeonSuperAdminEdit extends StatefulWidget {
  const NeonSuperAdminEdit({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _NeonSuperAdminEditState createState() => _NeonSuperAdminEditState();
}

class _NeonSuperAdminEditState extends State<NeonSuperAdminEdit> {
  List<dynamic> _mosques = [];
  dynamic _selectedMosque;
  bool _isLoading = true;
  bool _isUpdating = false;
  bool _isUploadingPhoto = false;

  final TextEditingController _fajrController = TextEditingController();
  final TextEditingController _dhuhrController = TextEditingController();
  final TextEditingController _asrController = TextEditingController();
  final TextEditingController _maghribController = TextEditingController();
  final TextEditingController _ishaController = TextEditingController();
  final TextEditingController _jummahController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mutawalliController = TextEditingController();
  final TextEditingController _imamController =
      TextEditingController(); // --- NAYA CONTROLLER ---
  final TextEditingController _mapLinkController = TextEditingController();

  List<String> _currentPhotos = [];

  @override
  void initState() {
    super.initState();
    _fetchMosques();
  }

  Future<void> _fetchMosques() async {
    try {
      final data = await SupaFlow.client.from('mosques').select();
      setState(() {
        _mosques = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching mosques: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onMosqueSelected(dynamic mosque) {
    setState(() {
      _selectedMosque = mosque;
      _fajrController.text = mosque['fajr']?.toString() ?? '';
      _dhuhrController.text = mosque['dhuhr']?.toString() ?? '';
      _asrController.text = mosque['asr']?.toString() ?? '';
      _maghribController.text = mosque['maghrib']?.toString() ?? '';
      _ishaController.text = mosque['isha']?.toString() ?? '';
      _jummahController.text = mosque['jummah']?.toString() ?? '';

      _addressController.text = mosque['address']?.toString() ?? '';
      _phoneController.text = mosque['phone_number']?.toString() ?? '';
      _mutawalliController.text = mosque['mutawalli_name']?.toString() ?? '';
      _imamController.text =
          mosque['imamName']?.toString() ?? ''; // --- NAYI LINE LIKHI HAI ---
      _mapLinkController.text = mosque['google_maps_link']?.toString() ?? '';

      var photosData = mosque['photos'];
      if (photosData is List) {
        _currentPhotos = photosData.map((e) => e.toString()).toList();
      } else {
        _currentPhotos = [];
      }
    });
  }

  Future<void> _uploadAndAddPhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _isUploadingPhoto = true;
        });

        Uint8List fileBytes = result.files.single.bytes!;
        String fileName =
            'masjid_${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';

        await SupaFlow.client.storage
            .from('masjid-photos')
            .uploadBinary(fileName, fileBytes);

        String publicUrl = SupaFlow.client.storage
            .from('masjid-photos')
            .getPublicUrl(fileName);

        setState(() {
          _currentPhotos.add(publicUrl);
          _isUploadingPhoto = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Photo Uploaded Successfully!',
                  style: TextStyle(fontFamily: 'Poppins')),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() {
        _isUploadingPhoto = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Upload Error: ${e.toString()}',
                style: const TextStyle(fontFamily: 'Poppins')),
            backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _updateTimings() async {
    if (_selectedMosque == null) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      await SupaFlow.client.from('mosques').update({
        'fajr': _fajrController.text.trim(),
        'dhuhr': _dhuhrController.text.trim(),
        'asr': _asrController.text.trim(),
        'maghrib': _maghribController.text.trim(),
        'isha': _ishaController.text.trim(),
        'jummah': _jummahController.text.trim(),
        'address': _addressController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'mutawalli_name': _mutawalliController.text.trim(),
        'imamName': _imamController.text
            .trim(), // --- DATABASE ME SAVE HONE KE LIYE NAYI LINE ---
        'google_maps_link': _mapLinkController.text.trim(),
        'photos': _currentPhotos,
      }).eq('id', _selectedMosque['id']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All Masjid Details & Photos Updated!',
              style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Poppins')),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _fajrController.dispose();
    _dhuhrController.dispose();
    _asrController.dispose();
    _maghribController.dispose();
    _ishaController.dispose();
    _jummahController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _mutawalliController.dispose();
    _imamController.dispose(); // --- NAYI LINE ---
    _mapLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: const Color(0xFF09090B),
        child: const Center(
            child: CircularProgressIndicator(color: Colors.cyanAccent)),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: const Color(0xFF09090B),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF12121A).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.6), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'SUPER ADMIN EDIT',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(color: Colors.cyanAccent, blurRadius: 10)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Select Mosque (All Visible)',
                    style: TextStyle(
                        color: Colors.cyanAccent, fontFamily: 'Poppins')),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      isExpanded: true,
                      dropdownColor: const Color(0xFF12121A),
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.cyanAccent),
                      value: _selectedMosque,
                      hint: const Text('Choose a Masjid...',
                          style: TextStyle(
                              color: Colors.white54, fontFamily: 'Poppins')),
                      items: _mosques.map((mosque) {
                        return DropdownMenuItem<dynamic>(
                          value: mosque,
                          child: Text(
                            mosque['name'] ?? 'Unknown',
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _onMosqueSelected(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_selectedMosque != null) ...[
                  const Text('NAMAZ TIMINGS',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  _buildTimeInput('Fajr', _fajrController),
                  _buildTimeInput('Dhuhr (Zuhar)', _dhuhrController),
                  _buildTimeInput('Asr', _asrController),
                  _buildTimeInput('Maghrib', _maghribController),
                  _buildTimeInput('Isha', _ishaController),
                  _buildTimeInput('Jummah', _jummahController, isSpecial: true),

                  const Divider(
                      color: Colors.white24, height: 40, thickness: 1),

                  const Text('MASJID INFO & DETAILS',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  _buildDetailInput(
                      'Address', _addressController, Icons.location_on),
                  _buildDetailInput(
                      'Phone Number', _phoneController, Icons.phone),
                  _buildDetailInput(
                      'Mutawalli Name', _mutawalliController, Icons.person),

                  // --- IMAM NAME KA NAYA INPUT BOX YAHAN ADD KIYA HAI ---
                  _buildDetailInput(
                      'Imam Name', _imamController, Icons.person_outline),

                  _buildDetailInput(
                      'Google Maps Link', _mapLinkController, Icons.map),

                  const SizedBox(height: 20),

                  const Text('MASJID PHOTOS',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 10),

                  // Image Upload Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton.icon(
                      onPressed: _isUploadingPhoto ? null : _uploadAndAddPhoto,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.cyanAccent),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: _isUploadingPhoto
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.cyanAccent, strokeWidth: 2))
                          : const Icon(Icons.add_a_photo,
                              color: Colors.cyanAccent),
                      label: Text(
                          _isUploadingPhoto
                              ? 'Uploading...'
                              : 'Upload New Photo from Device',
                          style: const TextStyle(
                              fontFamily: 'Poppins', color: Colors.cyanAccent)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_currentPhotos.isNotEmpty)
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _currentPhotos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(_currentPhotos[index],
                                      fit: BoxFit.cover, width: 90, height: 90),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _currentPhotos.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.close,
                                          size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Text('Koi photo uploaded nahi hai.',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white54,
                            fontSize: 12)),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isUpdating ? null : _updateTimings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 10,
                        shadowColor: Colors.cyanAccent.withOpacity(0.5),
                      ),
                      child: _isUpdating
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  'SAVE ALL DETAILS',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ] else ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'Select a mosque above to edit its details.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white54, fontFamily: 'Poppins'),
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInput(String label, TextEditingController controller,
      {bool isSpecial = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: isSpecial ? Colors.greenAccent : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: isSpecial ? Colors.greenAccent : Colors.yellowAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black26,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color:
                          isSpecial ? Colors.greenAccent : Colors.yellowAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailInput(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.cyanAccent,
            fontFamily: 'Poppins',
            fontSize: 13,
          ),
          prefixIcon: Icon(icon, color: Colors.cyanAccent, size: 20),
          filled: true,
          fillColor: Colors.black26,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.cyanAccent),
          ),
        ),
      ),
    );
  }
}
