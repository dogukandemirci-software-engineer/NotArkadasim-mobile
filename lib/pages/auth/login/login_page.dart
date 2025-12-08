import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_password_text_field/NA_password_text_field.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import 'package:note_arkadasim/models/login_model.dart';
import 'package:note_arkadasim/models/response_model/login_response_model.dart';
import 'package:note_arkadasim/services/api_services/auth_api/auth_service.dart';
import '../../../components/NA_button/NA_button.dart';
import '../../../components/NA_link/NA_link.dart';
import '../../../components/NA_popup/NA_popup.dart';
import '../../../components/NA_remember_me_checkbox/NA_remember_me_checkbox.dart';
import '../../../components/NA_text_field/NA_text_field.dart';
import '../../../components/enums/NA_popup_types.dart';
import '../../../components/show_snackbar/show_snackbar.dart';
import '../../../services/navigation_service/navigation_service.dart';
import '../../../themes/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> handleLogin() async {

    LoginModel loginModel = LoginModel.fromJson(
      {
       "email": _emailController.text,
       "password": _passwordController.text,
      }
    );

    LoginResponse loginResponse = await ApiService.instance.login(loginModel);

    print(loginResponse.isSuccess);
    print(loginResponse.errorType);
    print(loginResponse.errorMessage);

    if (loginResponse.isSuccess) {
      setState(() => _isLoading = false);
      showSnackBar(
        context,
        'Giriş başarılı!',
        successColor,
        icon: Icons.check_circle,
      );

      NavigationService.instance.go("/home");
    }
    else {
      setState(() {
        _isLoading = false;
      });
      buildNAPopup(
        context: context,
        type: PopupType.ERROR,
        title: "Giriş Başarısız",
        content: loginResponse.errorMessage,
        icon: Icons.error,
        onOk: () {
          Navigator.of(context).pop(); // Close the popup
        },
      );
    }
  }

  void handleRememberMe() {
    /// TO-DO
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
                            SizedBox(height: 30),
                            _buildNameFields(isSmallScreen, theme),
                            SizedBox(height: 24),
                            buildNAButton(
                              theme,
                              _isLoading,
                              handleLogin,
                              NAButtonTypes.LOGIN,
                              "Giriş Yap",
                              MediaQuery.of(context).size,
                            ),
                            SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                RememberMeCheckbox(
                                  initialValue: false,
                                  onChanged: (value) {
                                    print("Remember Me: $value");
                                    handleRememberMe();
                                  },
                                ),
                                buildLoginLink(
                                  theme,
                                  "Hesabınız yok mu? ",
                                  "Kayıt Ol",
                                  "/register",
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Center(
                              child: buildLoginLink(
                                theme,
                                "Şifremi unuttum ",
                                "Şifremi unuttum",
                                "/change-password",
                              ),
                            ),
                            SizedBox(height: 20),
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
    );
  }

  Widget _buildNameFields(bool isSmallScreen, ThemeData theme) {
    if (isSmallScreen) {
      return Column(
        children: [
          buildTextField(
            controller: _emailController,
            label: 'Email',
            validator: (value) => value?.isEmpty ?? true
                ? 'Lütfen email adresinizi giriniz'
                : null,
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 20),
          buildPasswordTextField(
            controller: _passwordController,
            label: 'Şifre',
            validator: (value) =>
            value?.isEmpty ?? true ? 'Şifre zorunludur' : null,
            prefixIcon: Icons.password,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: buildTextField(
            controller: _emailController,
            label: 'Email',
            validator: (value) => value?.isEmpty ?? true
                ? 'Lütfen email adresinizi giriniz'
                : null,
            prefixIcon: Icons.email,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: buildPasswordTextField(
            controller: _passwordController,
            label: 'Şifre',
            validator: (value) =>
            value?.isEmpty ?? true ? 'Şifre zorunludur' : null,
            prefixIcon: Icons.password,
          ),
        ),
      ],
    );
  }
}