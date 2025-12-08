import 'dart:io';
import 'package:easy_conffeti/easy_conffeti.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:note_arkadasim/components/NA_button/NA_button.dart';
import 'package:note_arkadasim/components/NA_classic_appbar/NA_classic_appbar.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import 'package:note_arkadasim/models/language.dart';
import 'package:note_arkadasim/models/lecture.dart';
import 'package:note_arkadasim/models/note_add_model.dart';
import 'package:note_arkadasim/models/tag.dart';
import 'package:note_arkadasim/services/api_services/note_api/note_api_service.dart';
import 'package:note_arkadasim/services/api_services/note_api/note_upsert_service.dart';
import '../../components/NA_multi_select_hashtag/NA_multi_select_hashtag.dart';
import '../../components/note_write_modal/note_write_modal.dart';

class AddNotePage extends StatefulWidget {
  final NoteUpsertService? noteUpsertService;
  final NoteApiService? noteApiService;

  const AddNotePage({super.key, this.noteUpsertService, this.noteApiService});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late final NoteUpsertService _noteUpsertService;
  late final NoteApiService _noteApiService;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isPublic = true;
  String? _selectedLanguageId;
  String? _selectedLectureId;
  PlatformFile? _selectedPdfFile;
  PlatformFile? _selectedImageFile;
  final Set<String> _selectedHashtagIds = {};

  bool _isLoading = false;
  bool _isDataLoading = true;

  List<Lecture> _lectures = [];
  List<Language> _languages = [];
  List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();
    _noteUpsertService = widget.noteUpsertService ?? NoteUpsertService();
    _noteApiService = widget.noteApiService ?? NoteApiService.instance;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isDataLoading = true);
    final data = await _noteUpsertService.getNoteUpsertData();
    if (data != null && mounted) {
      setState(() {
        _lectures = data.lectures;
        _languages = data.languages;
        _tags = data.tags;
      });
    } else if (mounted) {
      _showSnackBar('Not ekleme verileri yüklenemedi.', isError: true);
    }
    if (mounted) {
      setState(() => _isDataLoading = false);
    }
  }

  // ✅ DÜZELTİLMİŞ VERSİYON - Siyah ekran sorunu çözüldü
  Future<void> handlerFunction() async {
    // Form validasyonu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // PDF kontrolü
    if (_selectedPdfFile == null || _selectedPdfFile!.path == null) {
      _showSnackBar('Lütfen bir PDF dosyası seçiniz', isError: true);
      return;
    }

    // Dil kontrolü
    if (_selectedLanguageId == null) {
      _showSnackBar('Lütfen bir dil seçiniz', isError: true);
      return;
    }

    // Ders kontrolü
    if (_selectedLectureId == null) {
      _showSnackBar('Lütfen bir ders seçiniz', isError: true);
      return;
    }

    // Loading başlat
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // PDF yolu kontrolü
      final pdfFilePath = _selectedPdfFile!.path;
      if (pdfFilePath == null) {
        throw Exception('PDF yolu okunamadı');
      }

      // PDF dosyasının var olduğunu kontrol et
      final pdfFile = File(pdfFilePath);
      if (!await pdfFile.exists()) {
        throw Exception('PDF dosyası bulunamadı');
      }

      // Kapak resmi dosyası (varsa)
      File? coverImageFile;
      if (_selectedImageFile?.path != null) {
        final imagePath = _selectedImageFile!.path!;
        final imageFile = File(imagePath);
        if (await imageFile.exists()) {
          coverImageFile = imageFile;
        } else {
          print('⚠️ Kapak resmi bulunamadı, devam ediliyor...');
        }
      }

      // Not verisini oluştur
      final noteData = NoteAddModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isPublic: _isPublic,
        isComment: true,
        languageId: _selectedLanguageId!,
        noteFile: pdfFile,
        noteCoverimage: coverImageFile,
        tagIds: _selectedHashtagIds.toList(),
        lectureId: _selectedLectureId!,
      );

      print('📤 Not kaydediliyor...');

      // API çağrısı
      final success = await _noteApiService.addNote(noteData);

      if (!mounted) return;

      if (success) {
        _showSnackBar('Not başarıyla oluşturuldu!', isError: false);

        await ConfettiHelper.showConfettiDialog(
          context: context,
          confettiType: ConfettiType.celebration,
          confettiStyle: ConfettiStyle.star,
          animationStyle: AnimationConfetti.fireworks,
          colorTheme: ConfettiColorTheme.rainbow,
          message: "Tebrikler! 🎉",
          durationInSeconds: 2,
        );

        // Kısa bir gecikme ile geri dön (kullanıcı mesajı görsün)
        await Future.delayed(const Duration(milliseconds: 500));

      } else {
        throw Exception('Not kaydedilemedi');
      }

    } catch (e) {
      print('❌ Handler Error: $e');

      if (!mounted) return;

      // Hata mesajını kullanıcıya göster
      String errorMessage = 'Bir hata oluştu';

      if (e.toString().contains('timeout')) {
        errorMessage = 'Bağlantı zaman aşımına uğradı';
      } else if (e.toString().contains('network')) {
        errorMessage = 'İnternet bağlantısı hatası';
      } else if (e.toString().contains('dosya')) {
        errorMessage = 'Dosya okuma hatası';
      } else if (e is Exception) {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      _showSnackBar(errorMessage, isError: true);

    } finally {
      // Loading durdur
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFFF0003) : const Color(0xFF3EB75E),
        duration: Duration(seconds: isError ? 3 : 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Dosya yolu kontrolü
        if (file.path == null) {
          _showSnackBar('Dosya yolu okunamadı', isError: true);
          return;
        }

        // Dosya boyutu kontrolü (örnek: max 50MB)
        if (file.size > 50 * 1024 * 1024) {
          _showSnackBar('PDF dosyası 50MB\'dan küçük olmalıdır', isError: true);
          return;
        }

        setState(() {
          _selectedPdfFile = file;
        });

        print('✅ PDF seçildi: ${file.name} (${(file.size / 1024).toStringAsFixed(2)} KB)');
      }
    } catch (e) {
      print('❌ PDF seçme hatası: $e');
      _showSnackBar('PDF seçilirken hata oluştu', isError: true);
    }
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Dosya yolu kontrolü
        if (file.path == null) {
          _showSnackBar('Dosya yolu okunamadı', isError: true);
          return;
        }

        // Dosya boyutu kontrolü (örnek: max 10MB)
        if (file.size > 10 * 1024 * 1024) {
          _showSnackBar('Resim dosyası 10MB\'dan küçük olmalıdır', isError: true);
          return;
        }

        setState(() {
          _selectedImageFile = file;
        });

        print('✅ Resim seçildi: ${file.name} (${(file.size / 1024).toStringAsFixed(2)} KB)');
      }
    } catch (e) {
      print('❌ Resim seçme hatası: $e');
      _showSnackBar('Resim seçilirken hata oluştu', isError: true);
    }
  }

  void _removePdfFile() {
    setState(() {
      _selectedPdfFile = null;
    });
  }

  void _removeImageFile() {
    setState(() {
      _selectedImageFile = null;
    });
  }

  void _onHashtagToggle(String hashtagId) {
    setState(() {
      if (_selectedHashtagIds.contains(hashtagId)) {
        _selectedHashtagIds.remove(hashtagId);
      } else {
        _selectedHashtagIds.add(hashtagId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: buildAppBar(context, "Not Ekle", noLeading: true),
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
        child: _isDataLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
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
                    key: const Key('title_field'),
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
                    key: const Key('description_field'),
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
                title: 'Ders Seçimi',
                children: [
                  _buildLectureDropdown(),
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
                title: 'PDF Dosyası',
                children: [
                  _buildPdfPicker(),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Kapak Resmi (İsteğe bağlı)',
                children: [
                  _buildImagePicker(),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Hashtag\'ler',
                children: [
                  HashtagSelector(
                    availableHashtags: _tags.map((t) => t.name).toList(),
                    selectedHashtags: _tags
                        .where((t) => _selectedHashtagIds.contains(t.id))
                        .map((t) => t.name)
                        .toSet(),
                    onToggle: (tagName) {
                      final tag =
                      _tags.firstWhere((t) => t.name == tagName);
                      _onHashtagToggle(tag.id);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              buildNAButton(
                theme,
                _isLoading,
                handlerFunction,
                NAButtonTypes.ACCEPT,
                "Notu Kaydet",
                mediaQuery.size,
                key: const Key('save_button'),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
    Key? key,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF6B7385),
              size: 20,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF6B7385),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButtonFormField<String>(
      key: const Key('language_dropdown'),
      value: _selectedLanguageId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Dil',
        hintText: 'Dil seçiniz',
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          value: language.id,
          child: Text(
            language.name,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLanguageId = value;
        });
      },
    );
  }

  Widget _buildLectureDropdown() {
    return DropdownButtonFormField<String>(
      key: const Key('lecture_dropdown'),
      value: _selectedLectureId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Ders',
        hintText: 'Ders seçiniz',
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      items: _lectures.map((lecture) {
        return DropdownMenuItem(
          value: lecture.id,
          child: Text(
            lecture.name,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLectureId = value;
        });
      },
    );
  }

  Widget _buildPdfPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_selectedPdfFile != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3EB75E)),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Color(0xFF3EB75E)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedPdfFile!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF192335),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${(_selectedPdfFile!.size / 1024).toStringAsFixed(2)} KB',
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
                  onPressed: _removePdfFile,
                ),
              ],
            ),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: _pickPdf,
            icon: const Icon(Icons.upload_file),
            label: const Text('PDF Dosyası Ekle'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.purple, width: 2),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ElevatedButton(onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pop(); // modalı kapat
                  return false; // sistemin otomatik kapatmasını engelle
                },
                child: const NoteInputModal(),
              ),
            );

          }, child: Container(child: Text("PDF oluştur",
                style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                ),
              ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white , Colors.white70
              ])
            ),
            )
          )
        ],
        const SizedBox(height: 4),
        const Text(
          'Notunuzun ana içeriği PDF formatında olmalıdır.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7385),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_selectedImageFile != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3EB75E)),
            ),
            child: Row(
              children: [
                const Icon(Icons.image, color: Color(0xFF3EB75E)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedImageFile!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF192335),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${(_selectedImageFile!.size / 1024).toStringAsFixed(2)} KB',
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
                  onPressed: _removeImageFile,
                ),
              ],
            ),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Kapak Resmi Ekle'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.purple.withOpacity(0.5), width: 1.5),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
