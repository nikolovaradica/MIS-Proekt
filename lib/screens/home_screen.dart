import 'package:flutter/material.dart';
import 'package:lifelog/providers/daily_entry_provider.dart';
import 'package:lifelog/providers/quote_provider.dart';
import 'package:lifelog/providers/user_provider.dart';
import 'package:lifelog/screens/add_daily_entry_screen.dart';
import 'package:lifelog/screens/profile_screen.dart';
import 'package:lifelog/screens/view_daily_entry_screen.dart';
import 'package:lifelog/screens/view_graphs_screen.dart';
import 'package:lifelog/widgets/central_card.dart';
import 'package:lifelog/widgets/dark_theme_toggle_button.dart';
import 'package:lifelog/widgets/gradient_background.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();

  Future<void> _loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUser();
    final userId = userProvider.user?.uid;
    if (mounted) {
      Provider.of<QuoteProvider>(context, listen: false).loadQuotes();
      await Provider.of<DailyEntryProvider>(context, listen: false).fetchEntries(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final entries = Provider.of<DailyEntryProvider>(context).entries;
        final quoteProvider = Provider.of<QuoteProvider>(context);
        final quote = quoteProvider.currentQuote;

        return Scaffold(
          body: Stack(
            children: [
              const GradientBackground(showLogo: true),
              const Positioned(
                top: 40,
                right: 20,
                child: DarkThemeToggle(),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: CentralCard(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TableCalendar(
                                firstDay: DateTime.utc(2010),
                                lastDay: DateTime.utc(2030),
                                focusedDay: DateTime.now(),
                                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                  });
                                  final selectedDateOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                                  if (entries.containsKey(selectedDateOnly)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewDailyEntryScreen(
                                          selectedDate: _selectedDay,
                                          entry: entries[selectedDateOnly]!,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddDailyEntryScreen(
                                          selectedDate: _selectedDay
                                        ),
                                      ),
                                    );
                                  }
                                },
                                enabledDayPredicate: (day) {
                                  return !day.isAfter(DateTime.now());
                                },
                                calendarStyle: CalendarStyle(
                                  todayDecoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF5D9EEA), width: 2),
                                    
                                  ),
                                  selectedDecoration: const BoxDecoration(
                                    color: Color(0xFF5D9EEA),
                                    shape: BoxShape.circle,
                                  ),
                                  todayTextStyle: const TextStyle(
                                    color: Color(0xFF5D9EEA),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  markerDecoration: const BoxDecoration(
                                    color: Color(0xFF5D9EEA),
                                    shape: BoxShape.circle
                                  ),
                                  markersMaxCount: 1
                                ),
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF5D9EEA)),
                                  rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF5D9EEA)),
                                ),
                                eventLoader: (day) {
                                  final dateOnly = DateTime(day.year, day.month, day.day);
                                  return entries.containsKey(dateOnly) ? [entries[dateOnly]] : [];
                                },
                              ),
                              const Padding(padding: EdgeInsets.only(top: 60)),
                              const Text(
                                'Quote of the Day',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              Text(
                                quote != null ? '“${quote["quote"]}”' : 'Loading...',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 22,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  quote != null ? '- ${quote["author"]}' : '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 60)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewGraphsScreen(entries: entries),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5D9EEA),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'My Statistics',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5D9EEA),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
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
      },
    );
  }
}
