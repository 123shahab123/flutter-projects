import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OnboardingScreen(),
  ),
);

// ============ DATA ============

class _PageData {
  final IconData icon;
  final String title, desc;
  const _PageData(this.icon, this.title, this.desc);
}

const _pages = [
  _PageData(
    Icons.school,
    'Welcome to Campus',
    'Manage your courses, grades, and schedule — all in one beautiful place.',
  ),
  _PageData(
    Icons.auto_stories,
    'Track Your Learning',
    'See active and completed courses with detailed progress at a glance.',
  ),
  _PageData(
    Icons.rocket_launch,
    'Ready to Launch',
    "Let's start your learning journey today.",
  ),
];

// ============ ONBOARDING ============

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  static const _purple = Color(0xFF8B5CF6);
  static const _pink = Color(0xFFEC4899);

  // ONE controller drives the whole sequence
  late final AnimationController _ctrl;

  // Four staggered animations, each with a chosen curve
  late final Animation<double> _logoScale; // easeOutBack  → bouncy logo
  late final Animation<double> _titleFade; // easeOut      → smooth fade
  late final Animation<double> _descFade; // easeOut      → smooth fade
  late final Animation<Offset> _descSlide; // easeOutCubic → clean slide
  late final Animation<double> _btnFade; // easeOut      → smooth fade
  late final Animation<Offset> _btnSlide; // easeOutBack  → snappy pop

  int _index = 0;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
      reverseDuration: const Duration(milliseconds: 500), // faster replay
    );

    // 0.00 → 0.40  logo scales in
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    // 0.15 → 0.50  title fades in
    _titleFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.15, 0.5, curve: Curves.easeOut),
    );

    // 0.30 → 0.75  description slides + fades
    _descFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.3, 0.65, curve: Curves.easeOut),
    );
    _descSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.3, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    // 0.60 → 1.00  button arrives LAST
    _btnFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
    _btnSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
          ),
        );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Replay demo: reverse then forward
  void _replay() {
    _ctrl.reverse().then((_) {
      if (mounted) _ctrl.forward();
    });
  }

  void _continue() {
    if (_index < _pages.length - 1) {
      setState(() => _index++);
      _ctrl.forward(from: 0); // replay sequence for the new page
    } else {
      _navigate();
    }
  }

  void _navigate() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Widget _logo(IconData icon) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [_purple, _pink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.35),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Icon(icon, size: 60, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_index];
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F3FF), Color(0xFFFFF1F2)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // ---- top bar ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: 'Replay animation',
                      onPressed: _replay,
                      icon: const Icon(Icons.replay, color: _purple),
                    ),
                    TextButton(
                      onPressed: _navigate,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: _purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                // ---- animated content ----
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 1. Logo scales in (Hero shared with Home)
                      ScaleTransition(
                        scale: _logoScale,
                        child: Hero(tag: 'appLogo', child: _logo(page.icon)),
                      ),
                      const SizedBox(height: 40),

                      // 2. Title fades in
                      FadeTransition(
                        opacity: _titleFade,
                        child: Text(
                          page.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. Description slides + fades in
                      SlideTransition(
                        position: _descSlide,
                        child: FadeTransition(
                          opacity: _descFade,
                          child: Text(
                            page.desc,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---- page dots ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (i) {
                    final active = i == _index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active ? _purple : Colors.black26,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // 4. Button arrives LAST
                SlideTransition(
                  position: _btnSlide,
                  child: FadeTransition(
                    opacity: _btnFade,
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _continue,
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isLast ? 'Get Started' : 'Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============ HOME ============

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _purple = Color(0xFF8B5CF6);
  static const _pink = Color(0xFFEC4899);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F3FF), Color(0xFFFFF1F2)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Same Hero tag → logo flies here
                Hero(
                  tag: 'appLogo',
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [_purple, _pink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _purple.withValues(alpha: 0.35),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Welcome aboard!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your onboarding is complete.\nLet's explore your dashboard.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const OnboardingScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('Replay Onboarding'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
