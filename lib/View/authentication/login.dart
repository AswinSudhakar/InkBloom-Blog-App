import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/mainhome.dart';
import 'package:inkbloom/View/drawer/categorystart.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:inkbloom/models/user/usermodel.dart';
import 'package:inkbloom/service/authservice.dart';
import 'package:inkbloom/View/authentication/register.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isloading = false;
  UserProfileModel user = UserProfileModel();

  void _login() async {
    Authservice authservice = Authservice();
    if (_loginkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      try {
        final user = await authservice.login(
            _emailController.text, _passwordController.text);

        if (!mounted) return;

        if (user != null) {
          final userprovider =
              Provider.of<UserProvider>(context, listen: false);
          await userprovider.fetchandUpdate();

          final categories = userprovider.selectedCategories;
          if (categories == null || categories.isEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryScreenstart(),
              ),
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => Mainhome(),
              ),
              (route) => false,
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Invalid credentials. Please try again.")),
          );
          _emailController.clear();
          _passwordController.clear();

          Navigator.pop(context);
        }
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      } finally {
        if (!mounted) return;

        setState(() {
          _isloading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isloading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Lottie.asset('assets/animations/lottieeee.json'),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.grey.shade900,
                  Colors.grey.shade600,
                  Colors.grey.shade400,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontFamily: 'CrimsonText-Bold'),
                      ),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'CrimsonText-Bold'),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _loginkey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 60),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                    _buildTextField(_emailController, "Email",
                                        Icons.email, false),
                                    _buildTextField(_passwordController,
                                        "Password", Icons.lock, true),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 10),
                              _buildButton("Login", Colors.grey, _login),
                              const SizedBox(height: 20),
                              _buildButton("Register",
                                  const Color.fromARGB(255, 79, 118, 136), () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              }),
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
        ]),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      IconData icon, bool isPassword) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextFormField(
        style: TextStyle(
            color: Colors.grey, fontFamily: 'CrimsonText-SemiBoldItalic'),
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Colors.grey, fontFamily: 'CrimsonText-SemiBoldItalic'),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $hint';
          }
          return null;
        },
      ),
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
