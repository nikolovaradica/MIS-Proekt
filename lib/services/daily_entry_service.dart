import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lifelog/models/daily_entry.dart';

class DailyEntryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDailyEntry(DailyEntry entry, DateTime date) async {
    try {
      String docId = "${entry.userId}_${date.toIso8601String()}";

      if (entry.photoOfTheDayPath != null) {
        File imageFile = File(entry.photoOfTheDayPath!);
        String photoUrl = await uploadImage(imageFile);
        entry.photoOfTheDayPath = photoUrl;
      }
      // print("PAAAAAAAAAAAAAATH");
      // print(entry.photoOfTheDayPath);
      await _firestore.collection('daily_entries').doc(docId).set(entry.toMap());
    } catch (e) {
      print("Error adding daily entry: $e");
    }
  }

  Future<Map<DateTime, DailyEntry>> fetchDailyEntries(String userId) async {
    final snapshot = await _firestore
      .collection('daily_entries')
      .where('userId', isEqualTo: userId)
      .get();
    Map<DateTime, DailyEntry> entries = {};
    for (var doc in snapshot.docs) {
      var entry = DailyEntry.fromMap(doc.data());
      var date = DateTime.parse(doc.id.split('_')[1]);
      entries[date] = entry;
    }
    return entries;
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('photos/$fileName');

      UploadTask uploadTask = storageRef.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception('Image upload failed');
    }
  }
}