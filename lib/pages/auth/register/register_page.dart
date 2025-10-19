import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import 'package:note_arkadasim/services/api_services/get_initial_api/get_initial_upsert_service.dart';
import 'package:note_arkadasim/themes/theme.dart';

import '../../../components/NA_button/NA_button.dart';
import '../../../components/NA_classic_header/NA_classic_header.dart';
import '../../../components/NA_dropdown/NA_dropdown.dart';
import '../../../components/NA_link/NA_link.dart';
import '../../../components/NA_text_field/NA_text_field.dart';
import '../../../services/api_services/get_initial_api/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /// Component management variables
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// Variables
  String? _selectedCollege;
  String? _selectedDepartment;

  final titleRegister = "Kayit ol";

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _initialDataLoading = true;

  List<String> _colleges = [];
  List<String> _departments = [];

  /// Services
  final GetInitialUpsertService getInitialUpsertService = GetInitialUpsertService.instance;

  /// Local Functions
  /// Get College Names
  Future<List<String>> getCollegesAsStr() async {
    return getInitialUpsertService.getColleges().then((colleges) {
      return GetInitialUpsertServiceUtils.extractColleges(colleges);
    });
  }
  /// Get Department Names
  Future<List<String>> getDepartmentsAsStr() {
    return getInitialUpsertService.getDepartments().then((departments) {
      return GetInitialUpsertServiceUtils.extractDepartments(departments);
    });
  }

  Future<void> _loadInitialData() async {
    try {
      // Future.wait'i burada kullanıp sonuçları state'e kaydedebilirsiniz
      final results = await Future.wait([
        getCollegesAsStr(),
        getDepartmentsAsStr(),
      ]);

      setState(() {
        _colleges = results[0];
        _departments = results[1];
        _initialDataLoading = false;
      });
    } catch (e) {
      // Hata yönetimi
      setState(() => _initialDataLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email gereklidir';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir email adresi giriniz';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gereklidir';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre tekrarı gereklidir';
    }
    if (value != _passwordController.text) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCollege == null) {
        _showSnackBar(
          'Lütfen üniversite seçiniz',
          warningColor,
        );
        return;
      }

      if (_selectedDepartment == null) {
        _showSnackBar(
          'Lütfen bölüm seçiniz',
          warningColor,
        );
        return;
      }

      setState(() => _isLoading = true);

      // Simüle edilmiş API çağrısı
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        _showSnackBar(
          'Kayıt başarıyla tamamlandı!',
          successColor,
          icon: Icons.check_circle,
        );

        // Kayıt başarılı olduktan sonra giriş sayfasına yönlendirme
        // Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor, {IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: primaryFontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue], // mor → mavi
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isSmallScreen ? double.infinity : 600,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 40,
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildNAClassicHeader(theme),
                      const SizedBox(height: 32),
                      _buildNameFields(isSmallScreen, theme),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: _usernameController,
                        label: 'Kullanıcı Adı',
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Kullanıcı adı gereklidir'
                            : null,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),
                      buildDropdownField(
                        label: 'Üniversite',
                        value: _selectedCollege,
                        items:  _colleges,
                        onChanged: (value) =>
                            setState(() => _selectedCollege = value),
                        icon: Icons.school_outlined,
                        initialDataLoading: _initialDataLoading
                      ),
                      const SizedBox(height: 20),
                      buildDropdownField(
                        label: 'Bölüm',
                        value: _selectedDepartment,
                        items: _departments,
                        onChanged: (value) =>
                            setState(() => _selectedDepartment = value),
                        icon: Icons.menu_book_outlined,
                        initialDataLoading: _initialDataLoading
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: _passwordController,
                        label: 'Şifre',
                        obscureText: !_isPasswordVisible,
                        validator: _validatePassword,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: bodyTextColor,
                            size: 22,
                          ),
                          onPressed: () => setState(
                                  () => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Şifre Tekrarı',
                        obscureText: !_isConfirmPasswordVisible,
                        validator: _validateConfirmPassword,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: bodyTextColor,
                            size: 22,
                          ),
                          onPressed: () => setState(() =>
                          _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible),
                        ),
                      ),
                      const SizedBox(height: 32),
                      buildNAButton(theme,_isLoading, _handleRegister,NAButtonTypes.REGISTER , titleRegister,MediaQuery.of(context).size),
                      const SizedBox(height: 24),
                      buildLoginLink(theme, "Hesabınız var mı?", "Giriş Yap", "/login"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameFields(bool isSmallScreen, ThemeData theme) {
    if (isSmallScreen) {
      return Column(
        children: [
          buildTextField(
            controller: _nameController,
            label: 'Ad',
            validator: (value) =>
            value?.isEmpty ?? true ? 'Ad gereklidir' : null,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          buildTextField(
            controller: _surnameController,
            label: 'Soyad',
            validator: (value) =>
            value?.isEmpty ?? true ? 'Soyad gereklidir' : null,
            prefixIcon: Icons.person_outline,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: buildTextField(
            controller: _nameController,
            label: 'Ad',
            validator: (value) =>
            value?.isEmpty ?? true ? 'Ad gereklidir' : null,
            prefixIcon: Icons.person_outline,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: buildTextField(
            controller: _surnameController,
            label: 'Soyad',
            validator: (value) =>
            value?.isEmpty ?? true ? 'Soyad gereklidir' : null,
            prefixIcon: Icons.person_outline,
          ),
        ),
      ],
    );
  }


}