import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  String firstName;
  String lastName;
  String email;
  DateTime dateOfBirth;

  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "dateOfBirth": dateOfBirth.toIso8601String(),
    };
  }

  factory AppUser.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      dateOfBirth: DateTime.parse(data['dateOfBirth'] ?? DateTime.now().toIso8601String()),
    );
  }
}