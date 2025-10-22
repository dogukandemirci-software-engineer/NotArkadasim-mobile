import 'package:flutter/material.dart';


class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});


  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}


class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final _nameController = TextEditingController(text: 'Doğukan');
  final _emailController = TextEditingController(text: 'dogukan@example.com');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved (mock)')));
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}