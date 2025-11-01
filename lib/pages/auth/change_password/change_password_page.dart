
import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_text/NA_text.dart';
import 'package:note_arkadasim/services/navigation_service/navigation_service.dart';

import '../../../components/NA_button/NA_button.dart';
import '../../../components/NA_link/NA_link.dart';
import '../../../components/NA_text_field/NA_text_field.dart';
import '../../../components/enums/NA_button_types.dart';
import '../../../themes/theme.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  Future<void> handleChangePasswordEmail() async {
      /// TO-DO
      if(true) {
        NavigationService.instance.go("/login");
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 40.0),
                        child: const Text(
                          "E-posta adresini, telefon numaranı veya kullanıcı adını gir ve hesabına yeniden girebilmen için sana bir bağlantı gönderelim.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildNameFields(isSmallScreen, theme),
                      SizedBox(height: 20,),
                      buildNAButton(theme, _isLoading, handleChangePasswordEmail, NAButtonTypes.ACCEPT, "Şifre Sıfırla", MediaQuery.of(context).size),
                      SizedBox(height: 80,),
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
                ? 'Lütfen emailinizi giriniz'
                : null,
            prefixIcon: Icons.email,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: buildTextField(
            controller: _emailController,
            label: 'Password',
            validator: (value) => value?.isEmpty ?? true
                ? 'Lütfen passwordunuzu giriniz'
                : null,
            prefixIcon: Icons.password,
          ),
        ),
      ],
    );
  }

}
