import 'package:flutter/material.dart';

void main() {
  runApp(const TasbihApp());
}

class TasbihApp extends StatelessWidget {
  const TasbihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Tasbih',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7F3),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B45)),
      ),
      home: const TasbihScreen(),
    );
  }
}

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int count = 0;
  int target = 33;

  final List<int> targets = [33, 99, 100];

  void increaseCount() {
    if (count >= target) return;

    setState(() {
      count++;
    });

    if (count == target) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Alhamdulillah! Target completed.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF176B45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }
  }

  void resetCount() {
    setState(() {
      count = 0;
    });
  }

  double get progress {
    if (target == 0) return 0;
    return count / target;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF176B45),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Digital Tasbih',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            Text(
              'Dhikr Counter',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Dhikr text
              const Text(
                'سُبْحَانَ اللَّهِ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF176B45),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'SubhanAllah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),

              const SizedBox(height: 35),

              // Counter
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 245,
                    height: 245,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: const Color(0xFFDCE7E0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF176B45),
                      ),
                    ),
                  ),

                  Container(
                    width: 205,
                    height: 205,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF176B45),
                          ),
                        ),
                        Text(
                          'of $target',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // Target selection
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose Target',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: targets.map((value) {
                  final bool selected = target == value;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            target = value;
                            count = 0;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF176B45)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF176B45)
                                  : const Color(0xFFD9DED9),
                            ),
                          ),
                          child: Text(
                            '$value',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF333333),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const Spacer(),

              // Main count button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  key: const Key('countButton'),
                  onPressed: increaseCount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF176B45),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app_rounded),
                      SizedBox(width: 10),
                      Text(
                        'TAP TO COUNT',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Reset
              TextButton.icon(
                key: const Key('resetButton'),
                onPressed: resetCount,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reset Counter'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF555555),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
