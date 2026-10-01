// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class NeonAddPage extends StatefulWidget {
  const NeonAddPage({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _NeonAddPageState createState() => _NeonAddPageState();
}

class _NeonAddPageState extends State<NeonAddPage> {
  bool _isSaving = false;

  // Controllers for all fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _fajrController = TextEditingController();
  final TextEditingController _dhuhrController = TextEditingController();
  final TextEditingController _asrController = TextEditingController();
  final TextEditingController _maghribController = TextEditingController();
  final TextEditingController _ishaController = TextEditingController();
  final TextEditingController _jummahController = TextEditingController();

  Future<void> _addMosque() async {
    // Validation: Name aur Area khali nahi hone chahiye
    if (_nameController.text.trim().isEmpty ||
        _areaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Mosque Name and Address/Area.',
              style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await SupaFlow.client.from('mosques').insert({
        'name': _nameController.text.trim(),
        'area': _areaController.text.trim(),
        'fajr': _fajrController.text.trim(),
        'dhuhr': _dhuhrController.text.trim(),
        'asr': _asrController.text.trim(),
        'maghrib': _maghribController.text.trim(),
        'isha': _ishaController.text.trim(),
        'jummah': _jummahController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New Masjid Added Successfully!',
              style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: Colors.green,
        ),
      );

      // Save hone ke baad wapas Edit page par bhej do
      context.pop();
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
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => context.pop(), // Back button
                      child: const Icon(Icons.arrow_back_ios,
                          color: Colors.cyanAccent, size: 20),
                    ),
                    const Text(
                      'ADD MASJID',
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
                    const SizedBox(width: 20), // Spacing balance
                  ],
                ),
                const SizedBox(height: 30),

                _buildTextInput('Mosque Name', _nameController,
                    hint: 'e.g., Jama Masjid'),
                _buildTextInput('Address / Area', _areaController,
                    hint: 'e.g., Rampur City'),

                const Divider(color: Colors.white24, height: 40, thickness: 1),

                _buildTimeInput('Fajr', _fajrController),
                _buildTimeInput('Dhuhr', _dhuhrController),
                _buildTimeInput('Asr', _asrController),
                _buildTimeInput('Maghrib', _maghribController),
                _buildTimeInput('Isha', _ishaController),
                _buildTimeInput('Jummah', _jummahController, isSpecial: true),

                const SizedBox(height: 30),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _addMosque,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 10,
                      shadowColor: Colors.cyanAccent.withOpacity(0.5),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle, color: Colors.black),
                              SizedBox(width: 10),
                              Text(
                                'ADD MASJID',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller,
      {String hint = ''}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontFamily: 'Poppins',
                  fontSize: 12)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: const TextStyle(fontFamily: 'Poppins', color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.black26,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        ],
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
