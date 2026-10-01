// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class NeonEditPage extends StatefulWidget {
  const NeonEditPage({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _NeonEditPageState createState() => _NeonEditPageState();
}

class _NeonEditPageState extends State<NeonEditPage> {
  List<dynamic> _mosques = [];
  dynamic _selectedMosque;
  bool _isLoading = true;
  bool _isUpdating = false;

  // Time Fields Controllers
  final TextEditingController _fajrController = TextEditingController();
  final TextEditingController _dhuhrController = TextEditingController();
  final TextEditingController _asrController = TextEditingController();
  final TextEditingController _maghribController = TextEditingController();
  final TextEditingController _ishaController = TextEditingController();
  final TextEditingController _jummahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMosques();
  }

  Future<void> _fetchMosques() async {
    try {
      // --- NAYA FIX: User ki ID nikali aur Filter lagaya ---
      final currentUserId = SupaFlow.client.auth.currentUser?.id;

      if (currentUserId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Yahan .eq('user_id', currentUserId) se pakka filter lag gaya hai
      final data = await SupaFlow.client
          .from('mosques')
          .select()
          .eq('user_id', currentUserId);
      // -----------------------------------------------------

      setState(() {
        _mosques = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching mosques: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMosqueSelected(dynamic mosque) {
    setState(() {
      _selectedMosque = mosque;
      // Puraana time text fields mein auto-fill karne ke liye
      _fajrController.text = mosque['fajr']?.toString() ?? '';
      _dhuhrController.text = mosque['dhuhr']?.toString() ?? '';
      _asrController.text = mosque['asr']?.toString() ?? '';
      _maghribController.text = mosque['maghrib']?.toString() ?? '';
      _ishaController.text = mosque['isha']?.toString() ?? '';
      _jummahController.text = mosque['jummah']?.toString() ?? '';
    });
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
      }).eq('id', _selectedMosque['id']); // Ensure your primary key is 'id'

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timings Updated Successfully!',
              style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: Colors.green,
        ),
      );

      // Update hone ke baad wapas home page par bhej do
      context.pushNamed('HomePage');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}',
              style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
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
                    'EDIT TIMINGS',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
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

                // Select Mosque Dropdown
                const Text('Select Mosque',
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
                  _buildTimeInput('Fajr', _fajrController),
                  _buildTimeInput('Dhuhr (Zuhar)', _dhuhrController),
                  _buildTimeInput('Asr', _asrController),
                  _buildTimeInput('Maghrib', _maghribController),
                  _buildTimeInput('Isha', _ishaController),
                  _buildTimeInput('Jummah', _jummahController, isSpecial: true),

                  const SizedBox(height: 30),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isUpdating ? null : _updateTimings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellowAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        shadowColor: Colors.yellowAccent.withOpacity(0.5),
                      ),
                      child: _isUpdating
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  'SAVE TIMINGS',
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
                        'Select a mosque above to edit its timings.',
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
}
