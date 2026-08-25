import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/profile_provider.dart';
import '../models/user_profile.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentIndex = 0;
  final int _totalPages = 7;

  // Form Key for validation
  final _formKey = GlobalKey<FormState>();

  // State Variables
  String _name = '';
  String _mobileNumber = '';
  String _dateOfBirth = '';
  String _state = 'Delhi';
  String _education = 'B.Tech';
  String _branch = 'ECE';
  String _graduationYear = '2026';
  String _dailyStudyTime = '2 hours';
  final List<String> _targetJobs = [];

  final TextEditingController _dobController = TextEditingController();

  void _nextPage() {
    if (_currentIndex == 1 && !_formKey.currentState!.validate()) {
      return; // Stop if basic info is not filled
    }

    if (_currentIndex < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _skipToFinish() {
    _targetJobs.clear();
    _finish();
  }

  void _finish() async {
    final provider = context.read<ProfileProvider>();
    final newProfile = UserProfile(
      name: _name.isEmpty ? 'Aspirant' : _name,
      mobileNumber: _mobileNumber,
      dateOfBirth: _dateOfBirth,
      state: _state,
      education: _education,
      branch: _branch,
      graduationYear: _graduationYear,
      dailyStudyTime: _dailyStudyTime,
      targetJobs: _targetJobs,
      profileCompleted: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await provider.saveProfile(newProfile);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
        _dobController.text = _dateOfBirth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_currentIndex > 0)
              LinearProgressIndicator(value: _currentIndex / (_totalPages - 1)),
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  children: [
                    _buildWelcome(),
                    _buildStep1BasicInfo(),
                    _buildStep2Education(),
                    _buildStep3Branch(),
                    _buildStep4Graduation(),
                    _buildStep5StudyTime(),
                    _buildStep6TargetJobs(),
                  ],
                ),
              ),
            ),
            if (_currentIndex > 0)
              Padding(
                padding: const EdgeInsets.all(24),
                child: FilledButton(
                  onPressed: _nextPage,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _currentIndex == _totalPages - 1 ? 'Complete Profile 🎉' : 'Continue',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String subtitle, List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1.2)),
          const SizedBox(height: 12),
          Text(subtitle, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.outline)),
          const SizedBox(height: 40),
          ...children,
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Y',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onPrimaryContainer,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'YAJVIK',
            style: AppTheme.brandTextStyle(context).copyWith(color: Colors.white, fontSize: 32),
          ),
          const SizedBox(height: 48),
          const Text('Government Jobs.\nPreparation.\nYour Future.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.4), textAlign: TextAlign.center),
          const SizedBox(height: 64),
          FilledButton(
            onPressed: _nextPage,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Get Started', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          Text(
            'Your profile information is stored locally on this device.\nYAJVIK does not require an account.',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget _buildStep1BasicInfo() {
    return _buildStep(
      'Create Your Profile',
      'Please provide your basic details.',
      [
        TextFormField(
          initialValue: _name,
          onChanged: (v) => _name = v,
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          decoration: InputDecoration(
            labelText: 'Full Name',
            hintText: 'e.g. Kiran Kumar Reddy',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          initialValue: _mobileNumber,
          onChanged: (v) => _mobileNumber = v,
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Mobile Number',
            hintText: '+91 XXXXX XXXXX',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your number is used for job-alert preferences and notifications.',
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _dobController,
          readOnly: true,
          onTap: () => _selectDate(context),
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          value: _state,
          decoration: InputDecoration(labelText: 'State', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          items: ['Andhra Pradesh', 'Telangana', 'Delhi', 'Maharashtra', 'Karnataka', 'Tamil Nadu', 'Uttar Pradesh', 'Other']
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _state = v!),
        ),
      ],
    );
  }

  Widget _buildStep2Education() {
    return _buildStep(
      'What are you studying?',
      'Match with jobs you are eligible for.',
      [
        DropdownButtonFormField<String>(
          value: _education,
          decoration: InputDecoration(labelText: 'Education', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          items: ['10th', '12th', 'ITI', 'Diploma', 'B.E.', 'B.Tech', 'B.Sc', 'B.Com', 'B.A.', 'M.Tech', 'M.Sc', 'MBA', 'Other']
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _education = v!),
        ),
      ],
    );
  }

  Widget _buildStep3Branch() {
    return _buildStep(
      'Branch / Specialization',
      'Select your specific field of study.',
      [
        DropdownButtonFormField<String>(
          value: _branch,
          decoration: InputDecoration(labelText: 'Branch', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          items: ['ECE', 'CSE', 'EEE', 'Mechanical', 'Civil', 'IT', 'Other']
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _branch = v!),
        ),
      ],
    );
  }

  Widget _buildStep4Graduation() {
    return _buildStep(
      'Graduation Year',
      'Used to personalize government job eligibility.',
      [
        DropdownButtonFormField<String>(
          value: _graduationYear,
          decoration: InputDecoration(labelText: 'Year', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          items: ['2023', '2024', '2025', '2026', '2027', '2028', '2029', 'Other']
              .map((y) => DropdownMenuItem(value: y, child: Text(y)))
              .toList(),
          onChanged: (v) => setState(() => _graduationYear = v!),
        ),
      ],
    );
  }

  Widget _buildStep5StudyTime() {
    return _buildStep(
      'How much time can you study every day?',
      'Set your daily preparation goal.',
      [
        ...['15 minutes', '30 minutes', '1 hour', '2 hours', '3 hours', '4+ hours']
            .map((t) => RadioListTile(
                  title: Text(t),
                  value: t,
                  groupValue: _dailyStudyTime,
                  onChanged: (v) => setState(() => _dailyStudyTime = v.toString()),
                  contentPadding: EdgeInsets.zero,
                )),
      ],
    );
  }

  Widget _buildStep6TargetJobs() {
    return _buildStep(
      '🎯 What Government Job Are You Aiming For?',
      'Select multiple targets. You can skip this and explore later.',
      [
        const Text('Central Government', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['UPSC', 'SSC', 'Banking', 'Railway', 'Defence', 'Postal', 'Central PSU', 'Other Central Government']
              .map((exam) => FilterChip(
                    label: Text(exam),
                    selected: _targetJobs.contains(exam),
                    onSelected: (selected) => setState(() => selected ? _targetJobs.add(exam) : _targetJobs.remove(exam)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        const Text('State Government', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['State PSC', 'Police', 'Revenue', 'Group 1', 'Group 2', 'Group 3', 'Group 4', 'State PSU', 'Teacher', 'Other State Government']
              .map((exam) => FilterChip(
                    label: Text(exam),
                    selected: _targetJobs.contains(exam),
                    onSelected: (selected) => setState(() => selected ? _targetJobs.add(exam) : _targetJobs.remove(exam)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 48),
        Center(
          child: TextButton(
            onPressed: _skipToFinish,
            child: const Text('Skip for now', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
