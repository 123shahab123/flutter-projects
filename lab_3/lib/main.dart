import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Result',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const ResultScreen(),
    );
  }
}

// ============= MODEL =============

class Student {
  final String name;
  final List<int> marks;

  Student({required this.name, required this.marks});

  int get total => marks.fold(0, (s, m) => s + m);
  double get average => marks.isEmpty ? 0 : total / marks.length;
  bool get isPass => average >= 60;

  String get grade {
    if (marks.isEmpty) return 'N/A';
    if (average >= 90) return 'A';
    if (average >= 80) return 'B';
    if (average >= 70) return 'C';
    if (average >= 60) return 'D';
    return 'F';
  }
}

// ============= HELPERS =============

Color gradeColor(String g) {
  switch (g) {
    case 'A':
      return const Color(0xFF10B981); // mint
    case 'B':
      return const Color(0xFF3B82F6); // sky
    case 'C':
      return const Color(0xFF8B5CF6); // lavender
    case 'D':
      return const Color(0xFFF59E0B); // amber
    case 'F':
      return const Color(0xFFEF4444); // coral
    default:
      return const Color(0xFF94A3B8); // gray
  }
}

String gradeEmoji(String g) {
  switch (g) {
    case 'A':
      return '🌟';
    case 'B':
      return '⭐';
    case 'C':
      return '👍';
    case 'D':
      return '📚';
    case 'F':
      return '😅';
    default:
      return '❓';
  }
}

String gradeMessage(String g) {
  switch (g) {
    case 'A':
      return 'Outstanding performance!';
    case 'B':
      return 'Great work, keep it up!';
    case 'C':
      return 'Good job, keep going!';
    case 'D':
      return 'You passed — keep pushing!';
    case 'F':
      return 'Almost there — try again!';
    default:
      return 'No marks to show.';
  }
}

// ============= SCREEN =============

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final student = Student(name: 'Ali', marks: const [85, 92, 78, 88]);
    final color = gradeColor(student.grade);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F9FF), Color(0xFFFAF5FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _Header(student: student, color: color),
                const SizedBox(height: 20),
                _HeroCard(student: student, color: color),
                const SizedBox(height: 16),
                _MarksCard(student: student),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============= HEADER =============

class _Header extends StatelessWidget {
  final Student student;
  final Color color;
  const _Header({required this.student, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              student.name[0].toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'STUDENT RESULT',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                student.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Text(gradeEmoji(student.grade), style: const TextStyle(fontSize: 32)),
      ],
    );
  }
}

// ============= HERO CARD (ring) =============

class _HeroCard extends StatelessWidget {
  final Student student;
  final Color color;
  const _HeroCard({required this.student, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ring with average inside
          SizedBox(
            width: 170,
            height: 170,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 170,
                  height: 170,
                  child: CircularProgressIndicator(
                    value: student.average / 100,
                    strokeWidth: 14,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      student.average.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: color,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'AVERAGE',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Chip(text: 'Grade ${student.grade}', color: color),
              const SizedBox(width: 10),
              _Chip(
                text: student.isPass ? 'PASS' : 'FAIL',
                color: student.isPass
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Friendly message
          Text(
            gradeMessage(student.grade),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ============= MARKS CARD =============

class _MarksCard extends StatelessWidget {
  final Student student;
  const _MarksCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subjects',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (student.marks.isEmpty)
            const Text(
              'No marks entered',
              style: TextStyle(color: Colors.black54),
            )
          else
            ...student.marks.asMap().entries.map((e) {
              final i = e.key;
              final mark = e.value;
              final c = _markColor(mark);
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i == student.marks.length - 1 ? 0 : 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Subject ${i + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$mark',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: c,
                      ),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '${student.total}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _markColor(int m) {
    if (m >= 90) return const Color(0xFF10B981);
    if (m >= 80) return const Color(0xFF3B82F6);
    if (m >= 70) return const Color(0xFF8B5CF6);
    if (m >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}

// ============= SMALL CHIP =============

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  const _Chip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
