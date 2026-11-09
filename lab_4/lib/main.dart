import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const Screen(),
  ),
);

// ===== MODEL =====

mixin Logger {
  void log(String m) => debugPrint('📝 $m');
}

class Course {
  final String name, code;
  final int credits;
  final bool isElective;
  final Map<String, dynamic> metadata;

  Course({
    required this.name,
    required this.code,
    this.credits = 3,
    this.isElective = false,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? {};

  Course.elective({
    required this.name,
    required this.code,
    this.credits = 3,
    Map<String, dynamic>? metadata,
  }) : isElective = true,
       metadata = metadata ?? {};
}

class Student {
  final String name;
  final int semester;
  Student({required this.name, required this.semester});
}

class Registration with Logger {
  final Student student;
  final _required = <Course>[];
  final _electives = <Course>[];
  final _meta = <String, dynamic>{};
  bool _registered = false;

  Registration({required this.student});
  Registration.forStudent({required this.student});

  List<Course> get courses => [..._required, ..._electives];
  int get totalCourses => courses.length;
  int get requiredCount => _required.length;
  int get electiveCount => _electives.length;
  int get totalCredits => courses.fold(0, (s, c) => s + c.credits);
  bool get isRegistered => _registered;
  Map<String, dynamic> get metadata => Map.unmodifiable(_meta);

  void addRequired(Course c) => _required.add(c);
  void addElective(Course c) => _electives.add(c);
  void setMeta(String k, dynamic v) => _meta[k] = v;

  void register() {
    _registered = true;
    log('${student.name} registered for $totalCourses courses');
  }
}

// ===== UI =====

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final reg =
        Registration.forStudent(student: Student(name: 'Shahab', semester: 7))
          ..addRequired(Course(name: 'Flutter', code: 'CS301'))
          ..addRequired(Course(name: 'Software Engineering', code: 'CS302'))
          ..addElective(
            Course.elective(name: 'Firebase', code: 'CS310', credits: 2),
          )
          ..setMeta('Year', '2024-2025')
          ..setMeta('Mode', 'Hybrid')
          ..register();

    const p = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: p.withValues(alpha: 0.15),
                  child: Text(
                    reg.student.name[0],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: p,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'STUDENT',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 2,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        reg.student.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: p.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Sem ${reg.student.semester}',
                    style: const TextStyle(
                      color: p,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Summary
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: p.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL COURSES',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 2,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        '${reg.totalCourses}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: p,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          reg.isRegistered ? 'Registered' : 'Pending',
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Courses
            ...reg.courses.map((c) {
              final col = c.isElective ? const Color(0xFF06B6D4) : p;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: col.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      c.isElective ? Icons.auto_awesome : Icons.menu_book,
                      color: col,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${c.code} · ${c.credits} cr',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      c.isElective ? 'Elective' : 'Required',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: col,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Metadata
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registration Info',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...reg.metadata.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            e.key,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${e.value}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
