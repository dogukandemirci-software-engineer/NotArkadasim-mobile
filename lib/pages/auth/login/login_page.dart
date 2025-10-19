import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_password_text_field/NA_password_text_field.dart';
import 'package:note_arkadasim/components/NA_text/NA_text.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import '../../../components/NA_button/NA_button.dart';
import '../../../components/NA_link/NA_link.dart';
import '../../../components/NA_text_field/NA_text_field.dart';
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
    /// TO-DO
    if (true) {
      NavigationService.instance.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                        Center(
                          child: Image.asset(
                            'assets/images/logo_bg.png',
                            width: 150,   // istediğin genişlik
                            height: 150,  // istediğin yükseklik
                            fit: BoxFit.contain, // resmin orantısını korur
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildNameFields(isSmallScreen, theme),
                        SizedBox(height: 20,),
                        buildNAButton(theme, _isLoading, handleLogin, NAButtonTypes.LOGIN, "Giriş Yap", MediaQuery.of(context).size),
                        SizedBox(height: 10,),
                        buildLoginLink(theme , "Hesabınız yok mu? ", "Kayıt Ol", "/register" ),
                        SizedBox(height: 10,),
                        buildLoginLink(theme , "Şifremi unuttum ", "Şifremi unuttum", "/change-password" ),
                        SizedBox(height: 50,),
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
