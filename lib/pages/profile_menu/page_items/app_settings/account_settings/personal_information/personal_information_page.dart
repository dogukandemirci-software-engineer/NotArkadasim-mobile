import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_classic_appbar/NA_classic_appbar.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import 'package:note_arkadasim/services/api_services/get_initial_api/get_initial_upsert_service.dart';
import 'package:note_arkadasim/services/user_service.dart';
import 'package:note_arkadasim/themes/theme.dart';
import 'package:note_arkadasim/validation/validate_name.dart';
import 'package:note_arkadasim/validation/validate_password.dart';
import 'package:note_arkadasim/validation/validate_surname.dart';
import 'package:note_arkadasim/validation/validate_username.dart';
import '../../../../../../components/NA_button/NA_button.dart';
import '../../../../../../components/NA_dropdown/NA_dropdown.dart';
import '../../../../../../components/NA_text_field/NA_text_field.dart';
import '../../../../../../validation/email_validation.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  /// Component management variables
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  /// Variables
  String? _selectedCollege;
  String? _selectedDepartment;

  final titleUpdate = "Güncelle";

  bool _isLoading = false;
  bool _initialDataLoading = true;

  List<String> _colleges = [];
  List<String> _departments = [];

  /// Services
  final GetInitialUpsertService getInitialUpsertService = GetInitialUpsertService.instance;

  /// Local Functions

  Future<List<String>> getCollegesAsStr() async {
    final service = await getInitialUpsertService.getInitialUpsert();
    final colleges = service.resultInitialUpsert?.entity?.collages;
    if (colleges == null) return [];
    return colleges.map((c) => c.name).toList();
  }

  Future<List<String>> getDepartmentsAsStr() async {
    final service = await getInitialUpsertService.getInitialUpsert();
    final departments = service.resultInitialUpsert?.entity?.departments;
    if (departments == null) return [];
    return departments.map((d) => d.name).toList();
  }

  Future<void> _loadInitialData() async {
    try {
      final results = await Future.wait([
        getCollegesAsStr(),
        getDepartmentsAsStr(),
      ]);

      if (mounted) {
        setState(() {
          _colleges = results[0];
          _departments = results[1];
          _initialDataLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _initialDataLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await UserService().getUser();
      if (user != null && mounted) {
        // Kullanıcı adını boşluklara göre ayır
        List<String> nameParts = user.fullName.split(' ');
        String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        setState(() {
          _nameController.text = firstName;
          _surnameController.text = lastName;
          _emailController.text = user.email;
          _usernameController.text = user.username;
        });

        // Üniversite ve bölüm ID'lerine göre seçimleri yap
        if (user.univerityId != null && user.departmentId != null) {
          // ID'leri isimlere dönüştürmek için gerekli işlemleri yap
          final service = await getInitialUpsertService.getInitialUpsert();
          final universities = service.resultInitialUpsert?.entity?.collages ?? [];
          final departments = service.resultInitialUpsert?.entity?.departments ?? [];

          if (universities.isNotEmpty) {
            final selectedUniversity = universities.firstWhere(
              (uni) => uni.id == user.univerityId,
              orElse: () => universities.first,
            );
            
            if (mounted) {
              setState(() {
                _selectedCollege = selectedUniversity.name;
              });
            }
          }

          if (departments.isNotEmpty) {
            final selectedDepartment = departments.firstWhere(
              (dept) => dept.id == user.departmentId,
              orElse: () => departments.first,
            );
            
            if (mounted) {
              setState(() {
                _selectedDepartment = selectedDepartment.name;
              });
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Kullanıcı bilgileri yüklenirken hata oluştu: $e', errorColor);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
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
          'Bilgileriniz başarıyla güncellendi!',
          successColor,
          icon: Icons.check_circle,
        );
      }
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _ChangePasswordDialog(
          onSuccess: () {
            if (mounted) {
              _showSnackBar(
                'Şifreniz başarıyla değiştirildi!',
                successColor,
                icon: Icons.check_circle,
              );
            }
          },
        );
      },
    );
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
      appBar: buildAppBar(context, "Kişisel Bilgiler"),
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
                        items: _colleges,
                        onChanged: (value) =>
                            setState(() => _selectedCollege = value),
                        icon: Icons.school_outlined,
                        initialDataLoading: _initialDataLoading,
                      ),
                      const SizedBox(height: 20),
                      buildDropdownField(
                        label: 'Bölüm',
                        value: _selectedDepartment,
                        items: _departments,
                        onChanged: (value) =>
                            setState(() => _selectedDepartment = value),
                        icon: Icons.menu_book_outlined,
                        initialDataLoading: _initialDataLoading,
                      ),
                      const SizedBox(height: 32),
                      buildNAButton(
                        theme,
                        _isLoading,
                        _handleUpdate,
                        NAButtonTypes.REGISTER,
                        titleUpdate,
                        MediaQuery.of(context).size,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _showChangePasswordDialog,
                        icon: Icon(Icons.lock_outline, color: primaryColor),
                        label: Text(
                          'Şifre Değiştir',
                          style: TextStyle(
                            fontFamily: primaryFontFamily,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryColor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
            validator: validateName,
            prefixIcon: Icons.person_outline,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: buildTextField(
            controller: _surnameController,
            label: 'Soyad',
            validator: validateSurname,
            prefixIcon: Icons.person_outline,
          ),
        ),
      ],
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  final VoidCallback onSuccess;

  const _ChangePasswordDialog({required this.onSuccess});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _dialogFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
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

  Future<void> _handleChangePassword() async {
    if (_dialogFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simüle edilmiş API çağrısı
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dialogWidth = mediaQuery.size.width > 600 ? 500.0 : mediaQuery.size.width * 0.9;

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.7,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _dialogFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Şifre Değiştir',
                          style: TextStyle(
                            fontFamily: primaryFontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: bodyTextColor),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  buildTextField(
                    controller: _passwordController,
                    label: 'Yeni Şifre',
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
                    label: 'Yeni Şifre Tekrarı',
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
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: bodyTextColor.withOpacity(0.3), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'İptal',
                            style: TextStyle(
                              fontFamily: primaryFontFamily,
                              fontWeight: FontWeight.w600,
                              color: bodyTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleChangePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(
                            'Onayla',
                            style: TextStyle(
                              fontFamily: primaryFontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}