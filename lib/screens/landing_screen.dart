import 'package:flutter/material.dart';
import 'package:lifelog/screens/login_screen.dart';
import 'package:lifelog/screens/register_screen.dart';
import 'package:lifelog/widgets/gradient_background.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 600,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        'LifeLog',
                        style: TextStyle(
                          fontFamily: 'AnticDidone',
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Your personal mood & wellness tracker',
                        style: TextStyle(
                          fontFamily: 'AnticDidone',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 180),
                      const Text('New here?', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.maxFinite, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF5D9EEA),
                          elevation: 5,
                        ),
                        child: const Text('Register', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                      ),
                      const SizedBox(height: 30),
                      const Text('Already have an account?', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.maxFinite, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF5D9EEA),
                          elevation: 5,
                        ),
                        child: const Text('Login', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}