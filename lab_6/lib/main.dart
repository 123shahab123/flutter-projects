import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RegistrationScreen(),
  ),
);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  String? _department;
  bool _submitted = false;
  bool _obscurePassword = true;

  static const _departments = [
    'Computer Science',
    'Software Engineering',
    'Information Technology',
    'Cybersecurity',
    'Data Science',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    if (_department == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a department')),
      );
      return;
    }
    setState(() => _submitted = true);
  }

  void _reset() {
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _emailCtrl.clear();
    _idCtrl.clear();
    _passCtrl.clear();
    setState(() {
      _department = null;
      _submitted = false;
      _obscurePassword = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF8B5CF6);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        // ✅ Orientation-aware layout
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isLandscape = orientation == Orientation.landscape;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: isLandscape
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: _logo(purple),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(child: _form(purple)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _logo(purple),
                        const SizedBox(height: 24),
                        _form(purple),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  // ==================== LOGO ====================
  Widget _logo(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            // ✅ Local asset — falls back to icon if asset missing
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.school, size: 44, color: color),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Kabul University',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Student Registration',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  // ==================== FORM ====================
  Widget _form(Color purple) {
    return Container(
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _field(
              controller: _nameCtrl,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Name is required';
                if (v.trim().length < 3) return 'Min 3 characters';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _field(
              controller: _emailCtrl,
              label: 'Email',
              icon: Icons.email_outlined,
              type: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(v.trim())) {
                  return 'Invalid email format';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _field(
              controller: _idCtrl,
              label: 'Student ID',
              icon: Icons.badge_outlined,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Student ID required';
                if (v.trim().length < 5) return 'Min 5 characters';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passCtrl,
              obscureText: _obscurePassword,
              decoration: _decoration(
                label: 'Password',
                icon: Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password required';
                if (v.length < 6) return 'Min 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _departmentPicker(),
            const SizedBox(height: 20),
            // ✅ Modern buttons (FilledButton + OutlinedButton)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: purple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
            if (_submitted) ...[const SizedBox(height: 16), _successSummary()],
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      filled: true,
      fillColor: const Color(0xFFF5F3FF),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? type,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: _decoration(label: label, icon: icon),
      validator: validator,
    );
  }

  // ==================== DEPARTMENT (PopupMenuButton) ====================
  Widget _departmentPicker() {
    return PopupMenuButton<String>(
      onSelected: (v) => setState(() => _department = v),
      itemBuilder: (_) => _departments
          .map((d) => PopupMenuItem(value: d, child: Text(d)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _department == null ? Colors.black26 : Colors.black45,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.school_outlined, color: Colors.black54, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _department ?? 'Select Department',
                style: TextStyle(
                  color: _department == null ? Colors.black54 : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  // ==================== SUCCESS SUMMARY ====================
  Widget _successSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF10B981), size: 22),
              SizedBox(width: 8),
              Text(
                'Registration Successful',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _row('Name', _nameCtrl.text),
          _row('Email', _emailCtrl.text),
          _row('ID', _idCtrl.text),
          _row('Dept', _department ?? '-'),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            k,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        Expanded(
          child: Text(
            v,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
