// employees_page.dart

import 'package:buisness/components/add_employees.dart';
import 'package:flutter/material.dart'; // Import the new dialog

class EmployeesPage extends StatelessWidget {
  final Map<String, dynamic> business; 
  const EmployeesPage({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employees"),
      ),
      body: const Row(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.inversePrimary),
        onPressed: () => hireEmployee(context), // Use the new dialog
      ),
    );
  }

  void hireEmployee(BuildContext context) {
    AddEmployeeDialog.show(context, business['_id']); // Call the new dialog
  }
}
