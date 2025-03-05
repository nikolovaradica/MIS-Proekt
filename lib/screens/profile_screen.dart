import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifelog/providers/user_provider.dart';
import 'package:lifelog/screens/landing_screen.dart';
import 'package:lifelog/services/auth_service.dart';
import 'package:lifelog/widgets/central_card.dart';
import 'package:lifelog/widgets/custom_text_form_field.dart';
import 'package:lifelog/widgets/gradient_background.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if(userProvider.user == null) {
      await userProvider.loadUser();
    }
    
    final user = userProvider.user;
    if (user != null) {
      setState(() {
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _emailController.text = user.email;
        _dateOfBirthController.text = user.dateOfBirth.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _saveProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (user != null && firebaseUser != null) {
      try {
        if (_newPasswordController.text.isNotEmpty) {
          await AuthService().reauthenticate(firebaseUser.email!, _currentPasswordController.text);
          await firebaseUser.updatePassword(_newPasswordController.text);
          _currentPasswordController.text = _newPasswordController.text;
        }
        if (_emailController.text != user.email) {
          if (_currentPasswordController.text.isEmpty && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Please enter your password to confirm changes', 
                  style: TextStyle(color: Color(0xFF5D9EEA)),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
            return;
          }
          await AuthService().reauthenticate(firebaseUser.email!, _currentPasswordController.text);
          await firebaseUser.verifyBeforeUpdateEmail(_emailController.text);
        }
        user.firstName = _firstNameController.text;
        user.lastName = _lastNameController.text;
        user.email = _emailController.text;
        user.dateOfBirth = DateTime.parse(_dateOfBirthController.text);

        await userProvider.updateUser(user);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Profile updated successfully', 
                style: TextStyle(color: Color(0xFF5D9EEA)),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.code, 
                style: const TextStyle(color: Color(0xFF5D9EEA)),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF5D9EEA),),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(showLogo: true),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: CentralCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          CustomTextFormField(
                            label: 'First Name', 
                            controller: _firstNameController
                          ),
                          CustomTextFormField(
                            label: 'Last Name', 
                            controller: _lastNameController,
                          ),
                          CustomTextFormField(
                            label: 'Email',
                            controller: _emailController
                          ),
                          CustomTextFormField(
                            label: 'New Password',
                            controller: _newPasswordController,
                            obscureText: _obscureNewPassword,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureNewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined, color: const Color.fromARGB(255, 207, 207, 207),),
                              onPressed: () {
                                setState(() {
                                  _obscureNewPassword = !_obscureNewPassword;
                                });
                              },
                            ),
                          ),
                          CustomTextFormField(
                            label: 'Confirm Old Password', 
                            controller: _currentPasswordController, 
                            obscureText: _obscureCurrentPassword,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureCurrentPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined, color: const Color.fromARGB(255, 207, 207, 207),),
                              onPressed: () {
                                setState(() {
                                  _obscureCurrentPassword = !_obscureCurrentPassword;
                                });
                              },
                            ),
                          ),
                          CustomTextFormField(
                            label: 'Date of Birth',
                            controller: _dateOfBirthController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: user.dateOfBirth,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: Theme.of(context).brightness == Brightness.dark
                                        ? ColorScheme.dark(
                                            primary: const Color(0xFF5D9EEA),
                                            surface: Colors.grey[850]!,
                                          )
                                        : const ColorScheme.light(
                                            primary: Color(0xFF5D9EEA)
                                          ),
                                    ),
                                    child: child!
                                  );
                                }
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _dateOfBirthController.text = pickedDate.toLocal().toString().split(' ')[0];
                                });
                              }
                            },
                            suffixIcon: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 207, 207, 207)),
                          ),
                          ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.maxFinite, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF5D9EEA),
                            ),  
                            child: const Text('Save'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await AuthService().logout();
                              if(context.mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => const LandingScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.maxFinite, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF5D9EEA),
                            ),  
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    ),
                ),
                )
            ),
          )
        ],
      ),
    );
  }
}