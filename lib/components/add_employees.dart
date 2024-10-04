// add_employee_dialog.dart

import 'package:buisness/components/custom/custom_input_field.dart';
import 'package:buisness/services/employee_services.dart';
import 'package:flutter/material.dart';

class AddEmployeeDialog {
  static void show(BuildContext context, String buisnessId) {
    final TextEditingController employeeEmailController = TextEditingController();
    final EmployeeService employeeService = EmployeeService(); // Create an instance of EmployeeService

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Add Employee")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInputField(controller: employeeEmailController, hint: "Email"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                "Add",
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onPressed: () async {
                String employeeEmail = employeeEmailController.text.trim();

                // Example validation check
                if (employeeEmail.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All fields must be filled")),
                  );
                } else {
                  try {
                    await employeeService.addEmployee(buisnessId, employeeEmail); // Call the service to add employee
                    Navigator.of(context).pop(); // Close the dialog on success
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add employee: $e")),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
