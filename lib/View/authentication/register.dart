import 'package:flutter/material.dart';
import 'package:inkbloom/View/additionalscreen/loadingscreen.dart';
import 'package:inkbloom/View/widgets/termsofuse.dart';
import 'package:inkbloom/service/authservice.dart';
import 'package:inkbloom/View/authentication/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _register() async {
    if (_registerKey.currentState!.validate()) {
      if (!mounted) return;
      setState(() {});
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Loadingscreen(),
          ));
      Authservice authservice = Authservice();
      try {
        final user = await authservice.register(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );
        if (!mounted) return;

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration failed. Try again.")),
          );
          _usernameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          Navigator.pop(context);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'CrimsonText-Bold',
                        fontSize: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _registerKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _buildTextField(_usernameController,
                                      "Username", Icons.person, false),
                                  _buildTextField(_emailController, "Email",
                                      Icons.email, false),
                                  _buildTextField(_passwordController,
                                      "Password", Icons.lock, true),
                                  _buildTextField(_confirmPasswordController,
                                      "Confirm Password", Icons.lock, true,
                                      isConfirmPassword: true),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildButton("Register", Colors.grey, _register),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: const Text(
                                "Already have an account? Login",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 59, 98, 116),
                                    fontFamily: 'CrimsonText-SemiBoldItalic'),
                              ),
                            ),
                            Termsofuse()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      IconData icon, bool isPassword,
      {bool isConfirmPassword = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextFormField(
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontFamily: 'CrimsonText-SemiBoldItalic'),
          controller: controller,
          obscureText: isPassword
              ? (isConfirmPassword
                  ? !_isConfirmPasswordVisible
                  : !_isPasswordVisible)
              : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: 'CrimsonText-SemiBoldItalic'),
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (isConfirmPassword
                              ? !_isConfirmPasswordVisible
                              : !_isPasswordVisible)
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isConfirmPassword) {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        } else {
                          _isPasswordVisible = !_isPasswordVisible;
                        }
                      });
                    },
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $hint';
            } else if (hint == "Email" &&
                !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                    .hasMatch(value)) {
              return 'Enter a valid email address';
            } else if (isPassword && hint == "Password" && value.length < 6) {
              return 'Password must be at least 6 characters';
            } else if (hint == "Confirm Password" &&
                value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          }),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'CrimsonText-SemiBoldItalic'),
        ),
      ),
    );
  }
}
