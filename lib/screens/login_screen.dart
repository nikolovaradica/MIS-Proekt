import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lifelog/screens/home_screen.dart';
import 'package:lifelog/screens/register_screen.dart';
import 'package:lifelog/services/auth_service.dart';
import 'package:lifelog/widgets/custom_text_form_field.dart';
import 'package:lifelog/widgets/gradient_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please populate all fields', 
            style: TextStyle(color: Color(0xFF5D9EEA)),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      return;
    }

    User? user = await _authService.login(email, password);
    if(mounted) {
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Login failed', 
              style: TextStyle(color: Color(0xFF5D9EEA)),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      } 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          colors: [Color(0xFF94BCEB), Color(0xFFA49EF4)],
                                        ).createShader(bounds);
                                      },
                                      child: const Text(
                                        'Sign in to your account',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 5)),
                                    const Text("Don't give up on your mental wellness journey", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),),
                                    const Padding(padding: EdgeInsets.only(top: 120)),
                                    Column(
                                      children: [
                                        CustomTextFormField(
                                          label: 'Email',
                                          controller: _emailController,
                                        ),
                                        const Padding(padding: EdgeInsets.only(top: 30)),
                                        CustomTextFormField(
                                          label: 'Password',
                                          obscureText: _obscurePassword,
                                          controller: _passwordController,
                                          suffixIcon: IconButton(
                                            icon: Icon(_obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined, color: const Color.fromARGB(255, 207, 207, 207),),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword = !_obscurePassword;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 30)),
                                    ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(double.maxFinite, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xFF5D9EEA),
                                      ),
                                      child: const Text('Login'),
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 180)),
                                    RichText(
                                      text: TextSpan(
                                        text: "Don't have an account? ",
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w300, fontSize: 13), 
                                        children: [
                                          TextSpan(
                                            text: 'Register',
                                            style: const TextStyle(
                                              color: Color(0xFF5D9EEA),
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                                              },
                                          ),
                                        ],
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
                );
              },
            ),
          )
        ],
      ),
    );
  }  
}