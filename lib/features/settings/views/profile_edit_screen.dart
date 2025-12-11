import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncnsweat_mobile/data/models/profile_model.dart';
import 'package:syncnsweat_mobile/features/settings/controllers/profile_controller.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key, required this.profile});

  final ProfileModel profile;

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late FitnessGoal _fitnessGoal;
  late FitnessLevel _fitnessLevel;
  late List<String> _availableDays;
  late int _workoutDurationMinutes;

  @override
  void initState() {
    super.initState();
    _fitnessGoal = widget.profile.fitnessGoal;
    _fitnessLevel = widget.profile.fitnessLevel;
    _availableDays = List.from(widget.profile.availableDays);
    _workoutDurationMinutes = widget.profile.workoutDurationMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDropdown<FitnessGoal>(
            label: 'Fitness Goal',
            value: _fitnessGoal,
            items: FitnessGoal.values,
            onChanged: (value) {
              if (value != null) setState(() => _fitnessGoal = value);
            },
            itemLabelBuilder: (item) =>
                fitnessGoalToString(item).replaceAll('_', ' ').toUpperCase(),
          ),
          const SizedBox(height: 16),
          _buildDropdown<FitnessLevel>(
            label: 'Fitness Level',
            value: _fitnessLevel,
            items: FitnessLevel.values,
            onChanged: (value) {
              if (value != null) setState(() => _fitnessLevel = value);
            },
            itemLabelBuilder: (item) =>
                fitnessLevelToString(item).toUpperCase(),
          ),
          const SizedBox(height: 16),
          const Text('Available Days',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children:
                ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
              final isSelected = _availableDays.contains(day);
              return FilterChip(
                label: Text(day),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _availableDays.add(day);
                    } else {
                      _availableDays.remove(day);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _buildDropdown<int>(
            label: 'Workout Duration (minutes)',
            value: _workoutDurationMinutes,
            items: [15, 30, 45, 60, 90],
            onChanged: (value) {
              if (value != null)
                setState(() => _workoutDurationMinutes = value);
            },
            itemLabelBuilder: (item) => '$item mins',
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemLabelBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(itemLabelBuilder(item)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    ref.read(profileControllerProvider.notifier).updateProfile(
          name: widget.profile.name, // Keep existing name
          fitnessGoal: _fitnessGoal,
          fitnessLevel: _fitnessLevel,
          availableDays: _availableDays,
          workoutDurationMinutes: _workoutDurationMinutes,
        );
    Navigator.pop(context);
  }
}
