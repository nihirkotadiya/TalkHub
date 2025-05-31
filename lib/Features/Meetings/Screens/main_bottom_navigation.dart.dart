import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date
import 'package:zoom_clone/log_out_sceen.dart';
import 'meeting_screen.dart';

class ButtomNavigationTabs extends StatefulWidget {
  const ButtomNavigationTabs({super.key, required List<CameraDescription> cameras});

  @override
  State<ButtomNavigationTabs> createState() => _ButtomNavigationTabsState();
}

class _ButtomNavigationTabsState extends State<ButtomNavigationTabs> {
  int selectedIndex = 0;
  final TextEditingController _messageController = TextEditingController();
  final List<String> messages = [];
  DateTime selectedDate = DateTime.now();
  List<DateTime> scheduledMeetings = [];

  String getCurrentDate() {
    return DateFormat('EEEE, MMM d').format(selectedDate);
  }

  List<DateTime> getUpcomingDates() {
    return List.generate(10, (index) => DateTime.now().add(Duration(days: index)));
  }

  Widget buildChatScreen() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  messages[index],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Enter message',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.black,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    setState(() {
                      messages.add(_messageController.text);
                      _messageController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCalendarScreen() {
    List<DateTime> upcomingDates = getUpcomingDates();

    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: upcomingDates.length,
            itemBuilder: (context, index) {
              bool isSelected = DateFormat('yyyy-MM-dd').format(upcomingDates[index]) ==
                  DateFormat('yyyy-MM-dd').format(selectedDate);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = upcomingDates[index];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.grey[800],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('EEE').format(upcomingDates[index]),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CircleAvatar(
                        backgroundColor: isSelected ? Colors.white : Colors.blueGrey,
                        radius: 18,
                        child: Text(
                          DateFormat('d').format(upcomingDates[index]),
                          style: TextStyle(
                            color: isSelected ? Colors.blueAccent : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Selected Date: ${getCurrentDate()}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (!scheduledMeetings.contains(selectedDate)) {
                    scheduledMeetings.add(selectedDate);
                  }
                });
              },
              child: const Text('Schedule Meeting'),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: scheduledMeetings.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.blueGrey[800],
                child: ListTile(
                  title: Text(
                    'Meeting on ${DateFormat('EEEE, MMM d, yyyy').format(scheduledMeetings[index])}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        scheduledMeetings.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    if (selectedIndex == 0) {
      currentPage = const MeetingScreen();
    } else if (selectedIndex == 1) {
      currentPage = buildChatScreen();
    } else if (selectedIndex == 2) {
      currentPage = buildCalendarScreen();
    } else {
      currentPage = const LogoutScreen();
    }

    return Scaffold(
      body: Center(child: currentPage),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined, size: 27),
            label: 'Meetings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, size: 27),
            label: 'TeamChat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined, size: 27),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz, size: 27),
            label: 'More',
          ),
        ],
      ),
    );
  }
}