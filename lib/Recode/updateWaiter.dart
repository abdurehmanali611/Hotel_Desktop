// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class Updatewaiter extends StatelessWidget {
  final Map<String, dynamic> initialWaiterData;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController experienceController;
  final TextEditingController phoneController;
  final String? selectedSex; 
  final Function(String? newSex) onSexChanged; 
  final VoidCallback onCancel;
  final VoidCallback onUpdate;
  final String HotelName;

  const Updatewaiter({
    super.key,
    required this.initialWaiterData,
    required this.nameController,
    required this.ageController,
    required this.experienceController,
    required this.phoneController,
    required this.selectedSex,
    required this.onSexChanged,
    required this.onCancel,
    required this.onUpdate,
    required this.HotelName,
  });

  @override
  Widget build(BuildContext context) {
    if (initialWaiterData.isEmpty) {
      return const Center(child: Text("Waiter data not found."));
    }

    // Since the state (controllers, selectedSex) is managed by the parent,
    // this widget only handles presentation and calls the callbacks.
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          // Dropdown must trigger the parent state change via onSexChanged
          DropdownButtonFormField<String>(
            value: selectedSex,
            hint: const Text("Choose Sex..."),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Sex",
            ),
            items: const [
              DropdownMenuItem<String>(value: "Male", child: Text("Male")),
              DropdownMenuItem<String>(value: "Female", child: Text("Female")),
            ],
            onChanged: onSexChanged,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(
              labelText: "Age",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: experienceController,
            decoration: const InputDecoration(
              labelText: "Experience (Years)",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancel,
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onUpdate,
                child: const Text("Update"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
