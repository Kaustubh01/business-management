import 'package:buisness/components/custom/custom_input_field.dart';
import 'package:buisness/services/buisness_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class AddBusinessDialog extends StatelessWidget {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessDescriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final Function onBusinessAdded;
  
  AddBusinessDialog({super.key, required this.onBusinessAdded});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          "Add New Business",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInputField(
                controller: businessNameController,
                hint: "Name of business",
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: businessDescriptionController,
                hint: "Description (optional)",
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
        TextButton(
          child: Text(
            "Add",
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                // Call the service to create a business
                await createBusiness(
                  businessNameController.text.trim(),
                  businessDescriptionController.text.trim(),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Business created successfully')),
                );
                onBusinessAdded(); // Call the callback to refresh the business list
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please fill all required fields")),
              );
            }
          },
        ),
      ],
    );
  }
}
