import 'package:flutter/material.dart';

class TimelineEvent {
  final String year;
  final String description;

  TimelineEvent({required this.year, required this.description});
}

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<TimelineEvent> _timelineEvents = [
    TimelineEvent(year: '2020', description: 'Built my first Flutter app'),
    TimelineEvent(year: '2021', description: 'Interned at XYZ corp'),
    TimelineEvent(year: '2022', description: 'Released an open source package'),
    TimelineEvent(
        year: '2023', description: 'Worked on a project with 10k+ users'),
  ];

  int _selectedEvent = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors
            .transparent, // Make the Scaffold background color transparent
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _timelineEvents.asMap().entries.map((entry) {
                  int idx = entry.key;
                  TimelineEvent event = entry.value;
                  bool isSelected = idx == _selectedEvent;
                  return TimelineNode(
                    year: event.year,
                    description: event.description,
                    isSelected: isSelected,
                    onSelect: () => setState(() {
                      _selectedEvent = idx;
                    }),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineNode extends StatelessWidget {
  final String year;
  final String description;
  final bool isSelected;
  final VoidCallback onSelect;

  const TimelineNode({
    Key? key,
    required this.year,
    required this.description,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.orange : Colors.white,
              ),
            ),
            SizedBox(width: 20),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: isSelected ? MediaQuery.of(context).size.width * 0.6 : 0,
              height: isSelected ? 100 : 0,
              curve: Curves.fastOutSlowIn,
              child: Card(
                color: Colors.orange,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        year,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
