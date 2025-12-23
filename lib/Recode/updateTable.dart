// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class Updatetable extends StatelessWidget {
  final Map<String, dynamic> initialTableData;
  final TextEditingController tableNoController;
  final TextEditingController capacityController;
  final VoidCallback onCancel;
  final VoidCallback onUpdate;
  final String HotelName;

  const Updatetable({
    super.key,
    required this.initialTableData,
    required this.tableNoController,
    required this.capacityController,
    required this.onCancel,
    required this.onUpdate,
    required this.HotelName,
  });

  @override
  Widget build(BuildContext context) {
    if (initialTableData.isEmpty) {
      return const Center(child: Text("Table data not found."));
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: tableNoController,
            decoration: const InputDecoration(
              labelText: "Table Number",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: capacityController,
            decoration: const InputDecoration(
              labelText: "Capacity",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
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
