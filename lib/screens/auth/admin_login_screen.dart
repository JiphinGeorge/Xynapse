import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_router.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoggingIn = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack("Please enter admin credentials", Colors.redAccent);
      return;
    }

    setState(() => _isLoggingIn = true);
    await Future.delayed(const Duration(seconds: 1));

    if (email == "admin@xynapse.com" && password == "admin123") {
      _showSnack("Access Granted", Colors.greenAccent);
      Navigator.pushReplacementNamed(context, Routes.adminDashboard);
    } else {
      _showSnack("Invalid Credentials", Colors.redAccent);
    }

    setState(() => _isLoggingIn = false);
  }

  void _showSnack(String message, Color color) {
    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withValues(alpha: 0.9),
          border: Border.all(color: color, width: 1.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, color: color, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Admin Logo
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2C2C2E), Color(0xFF1A1A1C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amberAccent.withValues(alpha: 0.5),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFF0F0F13),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/xynapse_logo.png', // ✅ your logo
                          fit: BoxFit.cover,
                          height: 110,
                          width: 110,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                Text(
                  "ADMIN ACCESS PANEL",
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 45),

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  hint: "Admin Email",
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: 20),

                // Password Field
                _buildTextField(
                  controller: _passwordController,
                  hint: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 40),

                //  Login Button
                GestureDetector(
                  onTap: _isLoggingIn ? null : _login,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: _isLoggingIn
                            ? [Colors.grey.shade800, Colors.grey.shade700]
                            : const [Color(0xFF202428), Color(0xFF35383E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amberAccent.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoggingIn
                          ? const CircularProgressIndicator(
                              color: Colors.amberAccent,
                              strokeWidth: 2,
                            )
                          : Text(
                              "LOGIN AS ADMIN",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // ⚡️ Static Illustration / Icon
                Icon(
                  Icons.security_rounded,
                  size: 100,
                  color: Colors.amberAccent.withValues(alpha: 0.9),
                ),
                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, Routes.login),
                  child: Text(
                    "← Back to User Login",
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1A1C1E),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: Colors.amberAccent),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.amberAccent,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
