import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Student Portal',
    home: LoginScreen(),
  ),
);

// ================= MODELS =================

class Course {
  final String code, title, instructor;
  final int credits;
  final bool isActive;
  final double? grade;
  const Course({
    required this.code,
    required this.title,
    required this.instructor,
    required this.credits,
    required this.isActive,
    this.grade,
  });
}

const _courses = <Course>[
  Course(
    code: 'CS301',
    title: 'Flutter',
    instructor: 'Dr. Ahmad',
    credits: 3,
    isActive: true,
  ),
  Course(
    code: 'CS302',
    title: 'Software Engineering',
    instructor: 'Dr. Sara',
    credits: 3,
    isActive: true,
  ),
  Course(
    code: 'CS310',
    title: 'Firebase',
    instructor: 'Dr. Ali',
    credits: 2,
    isActive: true,
  ),
  Course(
    code: 'CS201',
    title: 'Data Structures',
    instructor: 'Dr. Omar',
    credits: 3,
    isActive: false,
    grade: 88,
  ),
  Course(
    code: 'CS202',
    title: 'Web Development',
    instructor: 'Dr. Nadia',
    credits: 3,
    isActive: false,
    grade: 92,
  ),
];

const _purple = Color(0xFF8B5CF6);

// ================= LOGIN =================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameCtrl = TextEditingController(text: 'Ahmad Karimi');
  final _passCtrl = TextEditingController(text: '123456');
  bool _loading = false;

  Future<void> _login() async {
    if (_nameCtrl.text.trim().isEmpty || _passCtrl.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a name and password (4+ chars)')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    // ✅ Replace login route so Back does not return to login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeShell(studentName: _nameCtrl.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: _purple.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school, size: 56, color: _purple),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Student Portal',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _loading ? null : _login,
                    style: FilledButton.styleFrom(
                      backgroundColor: _purple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Login', style: TextStyle(fontSize: 16)),
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

// ================= HOME SHELL (DRAWER) =================

class HomeShell extends StatefulWidget {
  final String studentName;
  const HomeShell({super.key, required this.studentName});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selected = 0;
  late String _name = widget.studentName;

  static const _titles = ['Dashboard', 'Courses', 'Profile', 'Settings'];
  static const _icons = [
    Icons.dashboard_outlined,
    Icons.menu_book_outlined,
    Icons.person_outline,
    Icons.settings_outlined,
  ];

  void _navigate(int i) {
    Navigator.pop(context); // close drawer
    setState(() => _selected = i);
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(name: _name, onGoCourses: () => _navigate(1)),
      const CoursesScreen(),
      ProfileScreen(name: _name, onUpdate: (n) => setState(() => _name = n)),
      const SettingsScreen(),
    ];

    // ✅ System back: on a non-Dashboard tab → return to Dashboard instead of exiting
    return PopScope(
      canPop: _selected == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _selected = 0);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selected]),
          backgroundColor: _purple,
          foregroundColor: Colors.white,
        ),
        drawer: _buildDrawer(),
        body: screens[_selected],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_purple, Color(0xFFEC4899)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Text(
                      _name.isNotEmpty ? _name[0] : '?',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _purple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'CS.SE.0731 · Semester 7',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _titles.length; i++)
              ListTile(
                leading: Icon(_icons[i]),
                title: Text(_titles[i]),
                selected: _selected == i,
                selectedColor: _purple,
                selectedTileColor: _purple.withValues(alpha: 0.08),
                onTap: () => _navigate(i),
              ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: _logout,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ================= DASHBOARD =================

class DashboardScreen extends StatelessWidget {
  final String name;
  final VoidCallback onGoCourses;
  const DashboardScreen({
    super.key,
    required this.name,
    required this.onGoCourses,
  });

  @override
  Widget build(BuildContext context) {
    final active = _courses.where((c) => c.isActive).length;
    final done = _courses.where((c) => !c.isActive).length;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome back,',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withValues(alpha: 0.54),
            ),
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _stat(
                  'Active',
                  '$active',
                  Icons.trending_up,
                  const Color(0xFF06B6D4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _stat(
                  'Completed',
                  '$done',
                  Icons.check_circle,
                  const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.arrow_forward, color: _purple),
              title: const Text(
                'Go to Courses',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: onGoCourses,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// ================= COURSES (TABS) =================

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: _purple,
            indicatorColor: _purple,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _list(context, _courses),
                _list(context, _courses.where((c) => c.isActive).toList()),
                _list(context, _courses.where((c) => !c.isActive).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _list(BuildContext context, List<Course> courses) {
    if (courses.isEmpty) {
      return const Center(child: Text('No courses here'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: courses.length,
      itemBuilder: (_, i) {
        final c = courses[i];
        final color = c.isActive
            ? const Color(0xFF06B6D4)
            : const Color(0xFF10B981);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                c.isActive ? Icons.play_circle : Icons.check_circle,
                color: color,
              ),
            ),
            title: Text(
              c.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${c.code} · ${c.credits} credits'),
            trailing: const Icon(Icons.chevron_right),
            // ✅ Stack navigation — push with typed Course object
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CourseDetailsScreen(course: c)),
            ),
          ),
        );
      },
    );
  }
}

// ================= COURSE DETAILS =================

class CourseDetailsScreen extends StatelessWidget {
  final Course course;
  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              course.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '${course.code} · ${course.credits} credits',
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _info(Icons.person_outline, 'Instructor', course.instructor),
            _info(
              Icons.timelapse,
              'Status',
              course.isActive ? 'Active' : 'Completed',
            ),
            if (course.grade != null)
              _info(
                Icons.grade,
                'Grade',
                '${course.grade!.toStringAsFixed(0)}%',
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Courses'),
              style: FilledButton.styleFrom(
                backgroundColor: _purple,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ================= PROFILE =================

class ProfileScreen extends StatelessWidget {
  final String name;
  final ValueChanged<String> onUpdate;
  const ProfileScreen({super.key, required this.name, required this.onUpdate});

  Future<void> _edit(BuildContext context) async {
    // ✅ Await a typed result from EditProfileScreen
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(currentName: name)),
    );
    if (result != null && result.isNotEmpty) {
      onUpdate(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 46,
              backgroundColor: _purple.withValues(alpha: 0.15),
              child: Text(
                name.isNotEmpty ? name[0] : '?',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: _purple,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text(
              'CS.SE.0731 · Semester 7',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text('Email'),
                  subtitle: Text('ahmad@uni.edu'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.phone_outlined),
                  title: Text('Phone'),
                  subtitle: Text('+93 700 000 000'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _edit(context),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            style: FilledButton.styleFrom(
              backgroundColor: _purple,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  const EditProfileScreen({super.key, required this.currentName});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final _ctrl = TextEditingController(text: widget.currentName);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _ctrl,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final t = _ctrl.text.trim();
                        if (t.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Name cannot be empty'),
                            ),
                          );
                          return;
                        }
                        // ✅ Return typed result — caller waits for it
                        Navigator.pop(context, t);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _purple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= SETTINGS =================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark Mode'),
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Language'),
                  trailing: Text('English'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                  trailing: Text('v1.0.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
