// import 'package:flutter/material.dart';
// import 'package:inkbloom/service/authservice.dart';

// import 'package:inkbloom/screens/login.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _registerKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   bool _isLoading = false;

//   void _register() async {
//     if (_registerKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       Authservice authservice = Authservice();
//       try {
//         final user = await authservice.Register(
//           _usernameController.text,
//           _emailController.text,
//           _passwordController.text,
//         );

//         if (user != null) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => LoginScreen()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Registration failed. Try again.")),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${e.toString()}")),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF6A89CC), Color(0xFFB8E994)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: Form(
//             key: _registerKey,
//             child: Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16)),
//               elevation: 6,
//               margin: const EdgeInsets.symmetric(horizontal: 24),
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Create Account",
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),

//                     // Username Field
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: _inputDecoration("Username", Icons.person),
//                       validator: (value) =>
//                           value!.isEmpty ? 'Enter a username' : null,
//                     ),
//                     const SizedBox(height: 15),

//                     // Email Field
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: _inputDecoration("Email", Icons.email),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
//                             .hasMatch(value)) {
//                           return 'Enter a valid email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 15),

//                     // Password Field
//                     TextFormField(_isPasswordVisible
//                       controller: _passwordController,
//                       obscureText: !,
//                       decoration:
//                           _inputDecoration("Password", Icons.lock).copyWith(
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                       ),
//                       validator: (value) => value!.length < 6
//                           ? 'Password must be at least 6 characters'
//                           : null,
//                     ),
//                     const SizedBox(height: 15),

//                     // Confirm Password Field
//                     TextFormField(
//                       controller: _confirmPasswordController,
//                       obscureText: !_isConfirmPasswordVisible,
//                       decoration:
//                           _inputDecoration("Confirm Password", Icons.lock)
//                               .copyWith(
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isConfirmPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isConfirmPasswordVisible =
//                                   !_isConfirmPasswordVisible;
//                             });
//                           },
//                         ),
//                       ),
//                       validator: (value) => value != _passwordController.text
//                           ? 'Passwords do not match'
//                           : null,
//                     ),
//                     const SizedBox(height: 20),

//                     // Register Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _register,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           backgroundColor: Colors.blueAccent,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                         ),
//                         child: _isLoading
//                             ? CircularProgressIndicator(color: Colors.white)
//                             : const Text("Register",
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white)),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => LoginScreen()),
//                         );
//                       },
//                       child: const Text("Already have an account? Login",
//                           style: TextStyle(color: Colors.blueAccent)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(icon, color: Colors.blueAccent),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:inkbloom/View/additionalscreen/loadingscreen.dart';
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
      } finally {
        if (!mounted) return;
        setState(() {});
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
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'CrimsonText-Bold',
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                    // Text(
                    //   'Welcome to InkBloom',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 30,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    // SizedBox(height: 25),
                    SizedBox(
                      height: 70,
                    )
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
                      key: _registerKey,
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
          style: TextStyle(
              color: Colors.grey, fontFamily: 'CrimsonText-SemiBoldItalic'),
          controller: controller,
          obscureText: isPassword
              ? (isConfirmPassword
                  ? !_isConfirmPasswordVisible
                  : !_isPasswordVisible)
              : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                color: Colors.grey, fontFamily: 'CrimsonText-SemiBoldItalic'),
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: Colors.grey),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (isConfirmPassword
                              ? !_isConfirmPasswordVisible
                              : !_isPasswordVisible)
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
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
