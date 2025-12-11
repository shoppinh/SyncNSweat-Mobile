import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncnsweat_mobile/data/models/preferences_model.dart';
import 'package:syncnsweat_mobile/features/settings/controllers/profile_controller.dart';

class PreferencesEditScreen extends ConsumerStatefulWidget {
  const PreferencesEditScreen({super.key, required this.preferences});

  final PreferencesModel preferences;

  @override
  ConsumerState<PreferencesEditScreen> createState() =>
      _PreferencesEditScreenState();
}

class _PreferencesEditScreenState extends ConsumerState<PreferencesEditScreen> {
  late List<String> _availableEquipment;
  late List<String> _targetMuscleGroups;
  late List<String> _musicGenres;
  String? _musicTempo;

  final List<String> _allEquipment = [
    'Dumbbells',
    'Barbell',
    'Kettlebell',
    'Resistance Bands',
    'Pull-up Bar',
    'Bench',
    'Yoga Mat',
    'None (Bodyweight)'
  ];

  final List<String> _allMuscleGroups = [
    'Chest',
    'Back',
    'Legs',
    'Arms',
    'Shoulders',
    'Abs',
    'Full Body'
  ];

  final List<String> _allMusicGenres = [
    'Pop',
    'Rock',
    'Hip Hop',
    'EDM',
    'Metal',
    'Classical',
    'Jazz'
  ];

  final List<String> _allTempos = ['Slow', 'Medium', 'Fast', 'Mixed'];

  @override
  void initState() {
    super.initState();
    _availableEquipment = List.from(widget.preferences.availableEquipment);
    _targetMuscleGroups = List.from(widget.preferences.targetMuscleGroups);
    _musicGenres = List.from(widget.preferences.musicGenres);
    _musicTempo = widget.preferences.musicTempo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Preferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePreferences,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMultiSelect(
            title: 'Available Equipment',
            items: _allEquipment,
            selectedItems: _availableEquipment,
            onChanged: (items) => setState(() => _availableEquipment = items),
          ),
          const SizedBox(height: 24),
          _buildMultiSelect(
            title: 'Target Muscle Groups',
            items: _allMuscleGroups,
            selectedItems: _targetMuscleGroups,
            onChanged: (items) => setState(() => _targetMuscleGroups = items),
          ),
          const SizedBox(height: 24),
          _buildMultiSelect(
            title: 'Music Genres',
            items: _allMusicGenres,
            selectedItems: _musicGenres,
            onChanged: (items) => setState(() => _musicGenres = items),
          ),
          const SizedBox(height: 24),
          const Text('Music Tempo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _allTempos.map((tempo) {
              return ChoiceChip(
                label: Text(tempo),
                selected: _musicTempo == tempo,
                onSelected: (selected) {
                  setState(() {
                    _musicTempo = selected ? tempo : null;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelect({
    required String title,
    required List<String> items,
    required List<String> selectedItems,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            return FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (selected) {
                final newSelectedItems = List<String>.from(selectedItems);
                if (selected) {
                  newSelectedItems.add(item);
                } else {
                  newSelectedItems.remove(item);
                }
                onChanged(newSelectedItems);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _savePreferences() {
    ref.read(preferencesControllerProvider.notifier).updatePreferences(
          availableEquipment: _availableEquipment,
          targetMuscleGroups: _targetMuscleGroups,
          musicGenres: _musicGenres,
          musicTempo: _musicTempo,
        );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences updated')),
    );
  }
}
