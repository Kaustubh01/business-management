import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Map<String, dynamic> business; 
  const SettingsPage({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SETTINGS"),
      ),
      body: ListView(
        children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              ),
              child: GestureDetector(
                child: const ListTile(
                  title: Text("Edit"),
                ),
                onTap: (){
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              ),
              child: GestureDetector(
                child: const ListTile(
                  title: Text("Delete Buisness"),
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/select_buisnesses');
                },
              ),
            )
        ],
      ),
    );
  }
}