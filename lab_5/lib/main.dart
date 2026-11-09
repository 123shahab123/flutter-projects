import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: ProfileScreen()),
);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF8B5CF6);
    const green = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      // ✅ SafeArea as top-level protection
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ✅ Title (Text)
              const Text(
                'Student Profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Profile card (Container + nested Row/Column)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: purple.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nested: Row (avatar + name + badge)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: purple.withValues(alpha: 0.15),
                          child: const Text(
                            'A',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: purple,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ahmad Karimi',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'CS.SE.0731 · Semester 7',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    // Info pairs (Row: icon + text)
                    _infoRow(
                      Icons.menu_book,
                      'Advanced Mobile Programming',
                      purple,
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      Icons.school,
                      'Computer Science & Engineering',
                      purple,
                    ),
                    const SizedBox(height: 10),
                    // ✅ Long text handled safely
                    _infoRow(
                      Icons.description,
                      'Passionate about cross-platform mobile development, '
                      'clean architecture, and building delightful user '
                      'experiences with Flutter and Firebase.',
                      purple,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ✅ Contact card (Container)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _infoRow(
                      Icons.email_outlined,
                      'ahmad.karimi@university.edu',
                      purple,
                    ),
                    const SizedBox(height: 10),
                    _infoRow(Icons.phone_outlined, '+93 700 123 456', purple),
                    const SizedBox(height: 10),
                    _infoRow(
                      Icons.location_on_outlined,
                      'Kabul, Afghanistan',
                      purple,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ✅ RichText for status line
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                    children: [
                      TextSpan(text: 'Status: '),
                      TextSpan(
                        text: 'Registered',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: green,
                        ),
                      ),
                      TextSpan(text: ' for '),
                      TextSpan(
                        text: '3 courses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                      TextSpan(text: ' this semester.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Reusable Row: icon + info (with safe long-text handling)
  static Widget _infoRow(
    IconData icon,
    String text,
    Color color, {
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
