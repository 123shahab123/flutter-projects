import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),

      home: CourseScreen(),
    );
  }
}

class CourseScreen extends StatelessWidget {
  CourseScreen({super.key});

  // Final fields
  final String courseTitle = 'Flutter & Dart';
  final String semester = 'Fall 2026';

  // List<String>
  final List<String> topics = [
    'Dart Basics',
    'Flutter Widgets',
    'Lists & Collections',
    'Conditions',
    'State Management',
  ];

  @override
  Widget build(BuildContext context) {
    // Selected value
    final String selectedTopic = topics[1];

    // Number of completed topics
    final int completedTopics = 3;

    // Boolean condition
    final bool isActive = completedTopics < topics.length;

    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF6),

      appBar: AppBar(
        title: const Text(
          'Practical Lab 5',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Course Overview',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF283593),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Learning Flutter with Dart',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // Course information card
            Card(
              elevation: 4,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    // Course
                    Row(
                      children: [
                        const Icon(
                          Icons.school,
                          size: 35,
                          color: Color(0xFF3F51B5),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                'Course',
                                style: TextStyle(color: Colors.black54),
                              ),

                              Text(
                                courseTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    // Semester
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 35,
                          color: Color(0xFF3F51B5),
                        ),

                        const SizedBox(width: 15),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              'Semester',
                              style: TextStyle(color: Colors.black54),
                            ),

                            Text(
                              semester,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Topics
            const Text(
              'Course Topics',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...topics.map(
              (topic) => Card(
                margin: const EdgeInsets.only(bottom: 8),

                child: ListTile(
                  leading: const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF3F51B5),
                  ),

                  title: Text(topic),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Selected topic
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 32),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Selected Topic',
                            style: TextStyle(color: Colors.black54),
                          ),

                          Text(
                            selectedTopic,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Status
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: isActive ? Colors.green.shade100 : Colors.red.shade100,

                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [
                  Icon(
                    isActive ? Icons.check_circle : Icons.cancel,

                    color: isActive ? Colors.green : Colors.red,
                  ),

                  const SizedBox(width: 12),

                  Text(
                    'Status: ${isActive ? 'Active' : 'Inactive'}',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,

                      color: isActive
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
