// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:go_router/go_router.dart';
import '/backend/supabase/supabase.dart'; // Ensure this matches your project's import

class NeonLoginPage extends StatefulWidget {
  const NeonLoginPage({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _NeonLoginPageState createState() => _NeonLoginPageState();
}

class _NeonLoginPageState extends State<NeonLoginPage> {
  // Toggle State (Login vs Register)
  bool _isLogin = true;

  // Login Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Registration Controllers
  final TextEditingController _regNameController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPhoneController = TextEditingController();
  final TextEditingController _regMasjidController = TextEditingController();
  final TextEditingController _regAddressController = TextEditingController();
  bool _isResponsibilityAccepted = false;
  bool _isRegLoading = false;

  // --- LOGIN LOGIC ---
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await SupaFlow.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!',
                style: TextStyle(fontFamily: 'Poppins')),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;

        // Super Admin Check (toLowerCase fix ke sath)
        if (response.user?.email?.toLowerCase() == 'udanish427@gmail.com') {
          context.pushNamed('SuperAdminPage');
        } else {
          context.pushNamed('EditTimePage');
        }
      }
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
          _isLoading = false;
        });
      }
    }
  }

  // --- REGISTER LOGIC (Ab data asli database mein jayega) ---
  Future<void> _handleRegister() async {
    // 1. Validation Check
    if (_regNameController.text.trim().isEmpty ||
        _regEmailController.text.trim().isEmpty ||
        _regPhoneController.text.trim().isEmpty ||
        _regMasjidController.text.trim().isEmpty ||
        _regAddressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sare fields bharna zaroori hai.',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 2. Checkbox Check
    if (!_isResponsibilityAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bhai, zimmedari ka checkbox tick karna zaroori hai.',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isRegLoading = true;
    });

    // 3. ASLI DATABASE INSERT LOGIC
    try {
      await SupaFlow.client.from('masjid_requests').insert({
        'name': _regNameController.text.trim(),
        'email': _regEmailController.text.trim(),
        'phone': _regPhoneController.text.trim(),
        'masjid_name': _regMasjidController.text.trim(),
        'address': _regAddressController.text.trim(),
      });
    } catch (e) {
      setState(() {
        _isRegLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Poppins')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return; // Agar error aaye toh aage mat badho
    }

    if (!mounted) return;

    setState(() {
      _isRegLoading = false;
    });

    // 4. Success Message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Hamari team aapko jaldi contact karegi Jazakallah khaira.',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );

    // 5. Form saaf karo aur wapas login page par aa jao
    _regNameController.clear();
    _regEmailController.clear();
    _regPhoneController.clear();
    _regMasjidController.clear();
    _regAddressController.clear();
    setState(() {
      _isResponsibilityAccepted = false;
      _isLogin = true;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _regNameController.dispose();
    _regEmailController.dispose();
    _regPhoneController.dispose();
    _regMasjidController.dispose();
    _regAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: const Color(0xFF09090B),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _isLogin ? _buildLoginForm() : _buildRegisterForm(),
            ),
          ),
        ),
      ),
    );
  }

  // ===================== LOGIN FORM UI =====================
  Widget _buildLoginForm() {
    return Container(
      key: const ValueKey(1),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Colors.cyanAccent.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.25),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'LOGIN',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2.0,
              shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 15)],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ACCESS YOUR ACCOUNT',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.cyanAccent.withOpacity(0.8),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _buildTextField(
              controller: _emailController,
              hintText: 'Email',
              icon: Icons.person_outline),
          const SizedBox(height: 20),
          _buildTextField(
              controller: _passwordController,
              hintText: 'Password',
              icon: Icons.lock_outline,
              isPassword: true),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 10,
                shadowColor: Colors.cyanAccent,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LOGIN',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.5)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, color: Colors.black),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
          // Forgot Password
          InkWell(
            onTap: () async {
              final email = _emailController.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter your email address first.',
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Colors.white)),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              try {
                await SupaFlow.client.auth.resetPasswordForEmail(email);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset link sent to your email!',
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
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Forgot Password?',
                  style: TextStyle(
                      color: Colors.cyanAccent.withOpacity(0.8),
                      fontFamily: 'Poppins',
                      fontSize: 13)),
            ),
          ),
          const Divider(color: Colors.white24, height: 30),
          // Go to Register Button
          InkWell(
            onTap: () {
              setState(() {
                _isLogin = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Don't have an account? Register Now",
                style: TextStyle(
                    color: Colors.yellowAccent.withOpacity(0.9),
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ===================== REGISTER FORM UI =====================
  Widget _buildRegisterForm() {
    return Container(
      key: const ValueKey(2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Colors.yellowAccent.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.yellowAccent.withOpacity(0.20),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'REGISTER',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2.0,
              shadows: [Shadow(color: Colors.yellowAccent, blurRadius: 10)],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ADD YOUR MASJID',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.yellowAccent.withOpacity(0.8),
                letterSpacing: 1.5),
          ),
          const SizedBox(height: 30),
          _buildTextField(
              controller: _regNameController,
              hintText: 'Your Name',
              icon: Icons.person),
          const SizedBox(height: 15),
          _buildTextField(
              controller: _regEmailController,
              hintText: 'Email ID',
              icon: Icons.email,
              isEmail: true),
          const SizedBox(height: 15),
          _buildTextField(
              controller: _regPhoneController,
              hintText: 'Phone Number',
              icon: Icons.phone,
              isPhone: true),
          const SizedBox(height: 15),
          _buildTextField(
              controller: _regMasjidController,
              hintText: 'Masjid Name',
              icon: Icons.mosque),
          const SizedBox(height: 15),
          _buildTextField(
              controller: _regAddressController,
              hintText: 'Masjid Address',
              icon: Icons.location_on,
              maxLines: 2),
          const SizedBox(height: 20),

          // Checkbox Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _isResponsibilityAccepted,
                    activeColor: Colors.yellowAccent,
                    checkColor: Colors.black,
                    side: const BorderSide(color: Colors.white54),
                    onChanged: (bool? value) {
                      setState(() {
                        _isResponsibilityAccepted = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Kya aap roz Namaz ka time update karne ki zimmedari le sakte hai?',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isRegLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 10,
                shadowColor: Colors.yellowAccent,
              ),
              child: _isRegLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('SUBMIT REQUEST',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1.2)),
            ),
          ),
          const SizedBox(height: 20),

          // Back to Login Button
          InkWell(
            onTap: () {
              setState(() {
                _isLogin = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Back to Login",
                style: TextStyle(
                    color: Colors.cyanAccent.withOpacity(0.9),
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ===================== HELPER FOR TEXT FIELDS =====================
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isEmail = false,
    bool isPhone = false,
    int maxLines = 1,
  }) {
    Color themeColor = _isLogin ? Colors.cyanAccent : Colors.yellowAccent;

    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      keyboardType: isPhone
          ? TextInputType.phone
          : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      maxLines: isPassword ? 1 : maxLines,
      style: const TextStyle(fontFamily: 'Poppins', color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hintText,
        hintStyle:
            const TextStyle(fontFamily: 'Poppins', color: Colors.white54),
        prefixIcon: Icon(icon, color: themeColor),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: themeColor.withOpacity(0.7),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 15 : 30),
          borderSide: const BorderSide(color: Colors.white24, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 15 : 30),
          borderSide: BorderSide(color: themeColor, width: 2),
        ),
      ),
    );
  }
}
