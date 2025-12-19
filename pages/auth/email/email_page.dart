

import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_button/NA_button.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import 'package:note_arkadasim/themes/theme.dart';
import '../../../components/NA_text/NA_text.dart';
import '../../../components/pinput/pinput_widget.dart';
import '../../../services/api_services/pin_check_api/pin_check_service.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {

  final PinCheckService pinCheckService = PinCheckService.instance;

  final naButtonTitle = "Yeniden gönder";

  bool isPinCorrect = false;
  bool isLoading = false;

  Future<void> checkPin(String pin) async {
    final isCorrect = await pinCheckService.checkPin();
    setState(() {
      isPinCorrect = isCorrect;
    });
  }

  Future<void> handlerReSend() async {

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: mediaQuery.size.height / 4,),
          buildNAText(context, "Pin Giriniz"),
          SizedBox(height: 10,),
          Text("Email'inizi kontrol ediniz."),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildPinPut(),
            ]
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Sağ ve sol padding
            child: Align(
              alignment: Alignment.center, // Ortalamak için
              child: buildNAButton(theme, isLoading, handlerReSend, NAButtonTypes.ACCEPT , naButtonTitle,MediaQuery.of(context).size),
            ),
          )
        ],
      ),
    );
  }
}
