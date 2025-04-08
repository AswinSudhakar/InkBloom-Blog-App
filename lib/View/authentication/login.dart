// import 'package:flutter/material.dart';
// import 'package:inkbloom/service/authservice.dart';
// import 'package:inkbloom/screens/home2.dart';
// import 'package:inkbloom/screens/register.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _loginkey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isLoading = false;

//   void _login() async {
//     if (_loginkey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       Authservice authservice = Authservice();
//       try {
//         final user = await authservice.login(
//             _emailController.text, _passwordController.text);

//         if (user != null) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen2()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Invalid credentials. Please try again.")),
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
//     _emailController.dispose();
//     _passwordController.dispose();
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
//             key: _loginkey,
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
//                       "Welcome Back!",
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),

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
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: !_isPasswordVisible,
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
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         } else if (value.length < 6) {
//                           return 'Password must be at least 6 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),

//                     // Login Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _login,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           backgroundColor: Colors.blueAccent,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                         ),
//                         child: _isLoading
//                             ? CircularProgressIndicator(color: Colors.white)
//                             : const Text("Login",
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white)),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextButton(
//                       onPressed: () {}, // Implement Forgot Password action
//                       child: const Text("Forgot Password?",
//                           style: TextStyle(color: Colors.blueAccent)),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RegisterScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text("Don't have an account? Sign Up",
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
import 'package:inkbloom/service/authservice.dart';
import 'package:inkbloom/View/blogscreens/home2.dart';
import 'package:inkbloom/View/authentication/register.dart';

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
  bool _isLoading = false;

  void _login() async {
    if (_loginkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Authservice authservice = Authservice();
      try {
        final user = await authservice.login(
            _emailController.text, _passwordController.text);

        if (!mounted) return;

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen2()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Invalid credentials. Please try again.")),
          );
        }
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      } finally {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.orange.shade900,
                Colors.orange.shade600,
                Colors.orange.shade400,
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
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
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
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildButton("Login", Colors.orange, _login),
                            const SizedBox(height: 20),
                            _buildButton("Register", Colors.lightBlueAccent,
                                () {
                              Navigator.push(
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
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.orange),
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
          ),
        ),
      ),
    );
  }
}
