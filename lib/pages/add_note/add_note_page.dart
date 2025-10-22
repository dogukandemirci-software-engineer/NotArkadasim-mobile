import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:note_arkadasim/components/NA_button/NA_button.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import '../../components/NA_multi_select_hashtag/NA_multi_select_hashtag.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isPublic = true;
  String? _selectedLanguage;
  PlatformFile? _selectedFile;
  final Set<String> _selectedHashtags = {};

  bool isLoading = false;

  Future<void> handlerFunction() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        _showSnackBar('Lütfen bir dosya seçiniz', isError: true);
        return;
      }

      if (_selectedLanguage == null) {
        _showSnackBar('Lütfen bir dil seçiniz', isError: true);
        return;
      }

      setState(() => isLoading = true);

      try {
        // Not kaydetme işlemi
        final noteData = {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'isPublic': _isPublic,
          'language': _selectedLanguage,
          'file': _selectedFile,
          'hashtags': _selectedHashtags.toList(),
        };

        // Simüle edilmiş gecikme
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          _showSnackBar('Not başarıyla oluşturuldu!', isError: false);
          Navigator.pop(context, noteData);
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Bir hata oluştu: $e', isError: true);
        }
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFFF0003) : const Color(0xFF3EB75E),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Sabit hashtag listesi
  final List<String> _availableHashtags = [
    'Matematik',
    'Fizik',
    'Kimya',
    'Biyoloji',
    'Tarih',
    'Coğrafya',
    'Edebiyat',
    'İngilizce',
    'Felsefe',
    'Programlama',
    'Veri Bilimi',
    'Yapay Zeka',
    'Web Geliştirme',
    'Mobil Geliştirme',
    'Tasarım',
  ];

  final List<String> _languages = [
    'Türkçe',
    'English',
    'Deutsch',
    'Français',
    'Español',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [type],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
    });
  }

  void _onHashtagToggle(String hashtag) {
    setState(() {
      if (_selectedHashtags.contains(hashtag)) {
        _selectedHashtags.remove(hashtag);
      } else {
        _selectedHashtags.add(hashtag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Yeni Not Oluştur'),
        backgroundColor: const Color(0xFF192335),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionCard(
              title: 'Temel Bilgiler',
              children: [
                _buildTextField(
                  controller: _titleController,
                  label: 'Başlık',
                  hint: 'Not başlığını giriniz',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Başlık zorunludur';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Açıklama',
                  hint: 'Not açıklamasını giriniz',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Açıklama zorunludur';
                    }
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Görünürlük',
              children: [
                _buildVisibilityToggle(),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Dil Seçimi',
              children: [
                _buildLanguageDropdown(),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Dosya',
              children: [
                _buildFilePicker(),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Hashtag\'ler',
              children: [
                HashtagSelector(
                  availableHashtags: _availableHashtags,
                  selectedHashtags: _selectedHashtags,
                  onToggle: _onHashtagToggle,
                ),
              ],
            ),
            const SizedBox(height: 24),
            buildNAButton(
              theme,
              isLoading,
              handlerFunction,
              NAButtonTypes.ACCEPT,
              "Notu Kaydet",
              mediaQuery.size,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFF0003), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFF0003)),
        ),
      ),
    );
  }

  Widget _buildVisibilityToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildVisibilityOption(
              icon: Icons.public,
              label: 'Herkese Açık',
              isSelected: _isPublic,
              onTap: () => setState(() => _isPublic = true),
            ),
          ),
          Expanded(
            child: _buildVisibilityOption(
              icon: Icons.lock,
              label: 'Özel',
              isSelected: !_isPublic,
              onTap: () => setState(() => _isPublic = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF6B7385),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF6B7385),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedLanguage,
      decoration: InputDecoration(
        labelText: 'Dil',
        hintText: 'Dil seçiniz',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2F57EF), width: 2),
        ),
      ),
      items: _languages.map((language) {
        return DropdownMenuItem(
          value: language,
          child: Text(language),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value;
        });
      },
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_selectedFile != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3EB75E)),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file, color: Color(0xFF3EB75E)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedFile!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF192335),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7385),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFFF0003)),
                  onPressed: _removeFile,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        OutlinedButton.icon(
          onPressed: () => _pickFile('pdf'),
          icon: const Icon(Icons.upload_file),
          label: Text(_selectedFile == null ? 'PDF dosya ekle' : 'Dosyayı Değiştir'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Colors.purple, width: 3),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const Text(
          'Desteklenen formatlar: PDF',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7385),
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => _pickFile('png'),
          icon: const Icon(Icons.upload_file),
          label: Text(_selectedFile == null ? 'Resim ekle' : 'Dosyayı Değiştir'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Colors.purple, width: 3),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Resim ekle: PNG , JPG',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7385),
          ),
        ),
      ],
    );
  }
}