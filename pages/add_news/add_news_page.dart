import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:image_picker/image_picker.dart'; // For image picking (optional)
import 'package:note_arkadasim/components/NA_button/NA_button.dart';
import 'package:note_arkadasim/components/NA_classic_appbar/NA_classic_appbar.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import 'dart:io';

import '../news/constants/fake_constants.dart';
import '../news/models/news_model.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({Key? key}) : super(key: key);

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _fullContentController = TextEditingController();
  final _authorController = TextEditingController();
  DateTime? _selectedDate;
  File? _imageFile; // For image picking (optional)
  final ImagePicker _picker = ImagePicker();


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _fullContentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  // Function to pick an image (optional, if you want to upload images)
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageUrlController.text = pickedFile.path; // Temporary, replace with actual URL after upload
      });
    }
  }

  // Function to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to generate a unique ID (simple implementation)
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future handlerFunction() async {
  }

  // Function to submit the form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newNews = News(
        id: _generateId(),
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        fullContent: _fullContentController.text,
        publishDate: _selectedDate ?? DateTime.now(),
        author: _authorController.text,
      );

      setState(() {
        newsItems.add(newNews); // Add to the newsItems list
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Haber başarıyla eklendi!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    }
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF192335),
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    bool isLoading = false;

    return Scaffold(
      appBar: buildAppBar(context, "Haber Ekle",noLeading: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildSectionCard(
                  title: 'Temel Bilgiler',
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Başlık',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Başlık zorunludur';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Açıklama',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Açıklama zorunludur';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Resim',
                  children: [
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Resim URL',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.image),
                          onPressed: _pickImage, // Optional image picker
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Resim URL zorunludur';
                        }
                        return null;
                      },
                    ),
                    if (_imageFile != null) ...[
                      const SizedBox(height: 16),
                      Image.file(_imageFile!, height: 100, fit: BoxFit.cover),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'İçerik',
                  children: [
                    TextFormField(
                      controller: _fullContentController,
                      decoration: const InputDecoration(
                        labelText: 'Tam İçerik',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tam içerik zorunludur';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Yazar ve Tarih',
                  children: [
                    TextFormField(
                      controller: _authorController,
                      decoration: const InputDecoration(
                        labelText: 'Yazar',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Yazar adı zorunludur';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(
                        _selectedDate == null
                            ? 'Yayın Tarihi Seç'
                            : 'Yayın Tarihi: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                buildNAButton(theme, isLoading, handlerFunction, NAButtonTypes.ACCEPT, "Haberi Ekle", mediaQuery.size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}