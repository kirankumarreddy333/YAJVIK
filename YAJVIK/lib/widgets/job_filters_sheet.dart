import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/government_job.dart';
import '../providers/job_provider.dart';

class JobFiltersSheet extends StatefulWidget {
  const JobFiltersSheet({super.key});

  @override
  State<JobFiltersSheet> createState() => _JobFiltersSheetState();
}

class _JobFiltersSheetState extends State<JobFiltersSheet> {
  String? _state;
  String? _qualification;
  GovernmentType? _govtType;

  @override
  void initState() {
    super.initState();
    final provider = context.read<JobProvider>();
    _state = provider.stateFilter;
    _qualification = provider.qualificationFilter;
    _govtType = provider.govtTypeFilter;
  }

  void _apply() {
    context.read<JobProvider>().setAdvancedFilters(
          state: _state,
          qualification: _qualification,
          govtType: _govtType,
        );
    Navigator.pop(context);
  }

  void _clear() {
    setState(() {
      _state = null;
      _qualification = null;
      _govtType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Jobs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _clear,
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _state,
            decoration: InputDecoration(
              labelText: 'State',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: ['Andhra Pradesh', 'Telangana', 'Delhi', 'Uttar Pradesh', 'Maharashtra', 'All India']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _state = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _qualification,
            decoration: InputDecoration(
              labelText: 'Qualification',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: ['10th Pass', '12th Pass', 'Diploma', 'Graduation', 'Post Graduation', 'BE/B.Tech']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _qualification = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<GovernmentType>(
            value: _govtType,
            decoration: InputDecoration(
              labelText: 'Sector',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: GovernmentType.values
                .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t == GovernmentType.central ? 'Central Government' : 'State Government'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _govtType = v),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _apply,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
