import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import 'package:note_arkadasim/models/College.dart';
import 'package:note_arkadasim/models/Department.dart';
import 'package:note_arkadasim/models/register_model.dart';
import 'package:note_arkadasim/models/response_model/register_response_model.dart';
import 'package:note_arkadasim/services/api_services/get_initial_api/get_initial_upsert_service.dart';
import 'package:note_arkadasim/themes/theme.dart';
import 'package:note_arkadasim/validation/validate_name.dart';
import 'package:note_arkadasim/validation/validate_password.dart';
import 'package:note_arkadasim/validation/validate_surname.dart';
import 'package:note_arkadasim/validation/validate_username.dart';
import '../../../components/NA_button/NA_button.dart';
import '../../../components/NA_dropdown/NA_dropdown.dart';
import '../../../components/NA_link/NA_link.dart';
import '../../../components/NA_popup/NA_popup.dart';
import '../../../components/NA_remember_me_checkbox/NA_remember_me_checkbox.dart';
import '../../../components/NA_text_field/NA_text_field.dart';
import '../../../components/enums/NA_popup_types.dart';
import '../../../components/show_snackbar/show_snackbar.dart';
import '../../../services/api_services/auth_api/auth_service.dart';
import '../../../validation/email_validation.dart';

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

  List<College> _collegeObjects = [];
  List<Department> _departmentObjects = [];
  List<String> _colleges = [];
  List<String> _departments = [];

  /// Services
  final GetInitialUpsertService getInitialUpsertService = GetInitialUpsertService.instance;

  /// Local Functions

  Future<void> _loadInitialData() async {
    try {
      final service = await getInitialUpsertService.getInitialUpsert();
      final colleges = service.resultInitialUpsert?.entity?.collages ?? [];
      final departments = service.resultInitialUpsert?.entity?.departments ?? [];

      setState(() {
        _collegeObjects = colleges;
        _departmentObjects = departments;
        _colleges = colleges.map((c) => c.name).toList();
        _departments = departments.map((d) => d.name).toList();
        _initialDataLoading = false;
      });
    } catch (e) {
      // Hata yönetimi
      setState(() => _initialDataLoading = false);
      showSnackBar(context,'Veri yüklenirken hata oluştu', Colors.red);
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre tekrarı gereklidir';
    }
    if (value != _passwordController.text) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  bool isLicenseAccepted = true;

  void acceptLicense(bool value) {
    setState(() {
      isLicenseAccepted = value;
    });
  }

  Future<void> _handleRegister() async {
    if (!isLicenseAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Koşulları kabul etmeniz gerekmekte."),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_selectedCollege == null) {
        showSnackBar(
          context,
          'Lütfen üniversite seçiniz',
          warningColor,
        );
        return;
      }

      if (_selectedDepartment == null) {
        showSnackBar(
          context,
          'Lütfen bölüm seçiniz',
          warningColor,
        );
        return;
      }

      setState(() => _isLoading = true);

      // Find the selected college and department objects to get their IDs
      final selectedCollegeObj = _collegeObjects.firstWhere(
        (college) => college.name == _selectedCollege,
        orElse: () => College(id: '', name: ''),
      );
      final selectedDepartmentObj = _departmentObjects.firstWhere(
        (department) => department.name == _selectedDepartment,
        orElse: () => Department(id: '', categoryId: '', name: ''),
      );

      RegisterModel registerModel = RegisterModel(
        userName: _usernameController.text.trim(),
        firstName: _nameController.text.trim(),
        lastName: _surnameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        collageId: selectedCollegeObj.id,
        departmentId: selectedDepartmentObj.id,
      );

      RegisterResponse registerResponse = await ApiService.instance.register(registerModel);

      if (registerResponse.isSuccess) {
        if (mounted) {
          setState(() => _isLoading = false);

          showSnackBar(
            context,
            'Kayıt başarıyla tamamlandı!',
            successColor,
            icon: Icons.check_circle,
          );

          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        buildNAPopup(
          context: context,
          type: PopupType.ERROR,
          title: "Kayıt Başarısız",
          content: registerResponse.errorMessage,
          icon: Icons.error,
          onOk: () {
            Navigator.of(context).pop(); // Close the popup
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
              Color(0xFF4facfe),
            ],
          ),
        ),
        child: SafeArea(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/images/logo_bg.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                _buildNameFields(isSmallScreen, theme),
                                const SizedBox(height: 20),
                                buildTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: validateEmail,
                                  prefixIcon: Icons.email_outlined,
                                ),
                                const SizedBox(height: 20),
                                buildTextField(
                                  controller: _usernameController,
                                  label: 'Kullanıcı Adı',
                                  validator: validateUsername,
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
                                  validator: validatePassword,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            RememberMeCheckbox(
                                              initialValue: true,
                                              label: "Şartları kabul et",
                                              onChanged: (value) {
                                                acceptLicense(value);
                                              },
                                            ),
                                            buildLoginLink(
                                              theme,
                                              "Not arkadasim ",
                                              "Şartları oku",
                                              "/accept-license",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
            validator: validateName,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          buildTextField(
            controller: _surnameController,
            label: 'Soyad',
            validator: validateSurname,
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