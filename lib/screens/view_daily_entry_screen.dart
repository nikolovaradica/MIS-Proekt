import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifelog/models/daily_entry.dart';
import 'package:lifelog/widgets/central_card.dart';
import 'package:lifelog/widgets/gradient_background.dart';
import 'package:lifelog/widgets/map_popup.dart';
import 'package:lifelog/widgets/mood_picker.dart';
import 'package:lifelog/widgets/section_title.dart';

class ViewDailyEntryScreen extends StatelessWidget {
  final DateTime selectedDate;
  final DailyEntry entry;

  const ViewDailyEntryScreen({
    super.key,
    required this.selectedDate,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(showLogo: true),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: CentralCard(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              DateFormat('dd MMMM yyyy').format(selectedDate),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SectionTitle(title: 'Mood'),
                            MoodPicker(
                              selectedMood: entry.mood,
                              onMoodSelected: (_) {},
                              readOnly: true,
                            ),
                            const SectionTitle(title: 'Sleep'),
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'From',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      entry.sleepStartTime.format(context),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'To',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      entry.sleepEndTime.format(context),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SectionTitle(title: 'Grateful For'),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: const Color.fromARGB(255, 231, 231, 231),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  entry.gratefulFor,
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                            const SectionTitle(title: 'Highlights'),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: const Color.fromARGB(255, 231, 231, 231),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  entry.highlights,
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                            const SectionTitle(title: 'Location'),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: const Color.fromARGB(255, 231, 231, 231),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        entry.location != null && (entry.location!.latitude != 0.0 || entry.location!.longitude != 0.0)
                                          ? 'Lat: ${entry.location?.latitude}, \nLng: ${entry.location?.longitude}'
                                          : 'Location not provided',
                                        style: const TextStyle(fontSize: 16, color: Colors.black),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    if (entry.location != null && (entry.location!.latitude != 0.0 || entry.location!.longitude != 0.0))
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context, 
                                            builder: (context) => MapPopup(location: entry.location!)
                                          );
                                        }, 
                                        tooltip: 'View on map', 
                                        icon: const Icon(Icons.location_on, size: 25, color: Color(0xFF5D9EEA),),
                                      )
                                  ],
                                ),
                              ),
                            ),
                            const SectionTitle(title: 'Photo of the Day'),
                            entry.photoOfTheDayPath.isEmpty
                              ? const Text('No photo recorded')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    entry.photoOfTheDayPath,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      (loadingProgress.expectedTotalBytes ?? 1)
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, size: 50, color: Colors.red),
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
        ],
      ),
    );
  }
}